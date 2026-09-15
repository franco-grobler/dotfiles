#!/usr/bin/env bash
# Resolves which flake output this machine builds from.
#
# Host configurations are keyed by the machine's own hostname, so adding a host
# to nix/modules/hosts/ is all it takes for this script to find it. Override by
# exporting NIXNAME before sourcing.
set -euo pipefail

is_nixos() {
	[ -f "/etc/NixOS/release" ] && return 0
	command -v nixos-version &>/dev/null && return 0
	return 1
}

os=$(uname -s)
case "$os" in
Darwin)
	export NIXNAME="${NIXNAME:-$(scutil --get LocalHostName)}"
	export NIXCONFIG="darwinConfigurations"
	;;
Linux)
	host="${NIXNAME:-$(hostname -s)}"
	if is_nixos; then
		export NIXNAME="$host"
		export NIXCONFIG="nixosConfigurations"
	else
		# Not NixOS: fall back to the stand-alone home-manager output.
		export NIXNAME="${USER}@${host}"
		export NIXCONFIG="homeConfigurations"
	fi
	;;
*)
	echo "Unsupported OS: $os" >&2
	exit 1
	;;
esac
