#!/usr/bin/env bash
# Dry run: builds this host and runs its activation checks, without activating.
#
# nix-darwin has no `test`; `check` is the equivalent, and it is what catches
# things like unexpected files in /etc before a real switch.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "${root}/_scripts/set_nix_envs.sh"
cd "${root}/nix"

echo "Checking ${NIXCONFIG}.${NIXNAME}"
case "${NIXCONFIG}" in
  darwinConfigurations) sudo darwin-rebuild check --flake ".#${NIXNAME}" ;;
  nixosConfigurations) sudo nixos-rebuild test --flake ".#${NIXNAME}" ;;
  homeConfigurations) home-manager build --flake ".#${NIXNAME}" ;;
esac
