#!/usr/bin/env bash
set -euo pipefail

is_nixos() {
	# Check if /etc/NixOS/release file exists
	if [ -f "/etc/NixOS/release" ]; then
		return 0
	fi

	# Check if the nixos-version command exists and is executable
	if command -v nixos-version &>/dev/null; then
		return 0
	fi

	# If neither condition is met, it's likely not NixOS
	return 1
}

os=$(uname -s)
if [[ $os == "Darwin" ]]; then
	export NIXNAME="apple-silicone"
	export NIXCONFIG="darwinConfigurations"
elif [[ $os == "Linux" ]]; then
	export NIXNAME="lenovo"
	if is_nixos; then
		export NIXCONFIG="nixosConfigurations"
	else
		export NIXCONFIG="homeConfigurations"
	fi
	if [[ $(uname -r) =~ WSL ]]; then
		export NIXNAME="wsl"
	fi
else
	echo "Unsupported OS: $os"
	exit 1
fi
