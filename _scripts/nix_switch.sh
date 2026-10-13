#!/usr/bin/env bash
# Activates this host's configuration.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "${root}/_scripts/set_nix_envs.sh"
cd "${root}/nix"

echo "Switching to ${NIXCONFIG}.${NIXNAME}"
case "${NIXCONFIG}" in
  darwinConfigurations) sudo darwin-rebuild switch --flake ".#${NIXNAME}" ;;
  nixosConfigurations) sudo nixos-rebuild switch --flake ".#${NIXNAME}" ;;
  homeConfigurations) home-manager switch --flake ".#${NIXNAME}" ;;
esac

# Determinate Nix is installed outside the flake, so a switch never updates
# it. Only nag, and only when behind; the upgrade restarts the daemon.
if [ "${NIXCONFIG}" = darwinConfigurations ]; then
  if ! notice=$("${root}/_scripts/nix_upgrade_check.sh"); then
    echo
    echo "${notice}"
  fi
fi
