#!/usr/bin/env bash
# First run on a fresh machine, before darwin-rebuild/nixos-rebuild exist.
#
# Calls nix_switch.sh directly rather than `just nix-switch`: on a fresh
# machine `just` usually comes from `nix run nixpkgs#just`, so it is not on
# PATH for a nested call.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "${root}/_scripts/set_nix_envs.sh"
cd "${root}/nix"

case "${NIXCONFIG}" in
  darwinConfigurations)
    nix build ".#${NIXCONFIG}.${NIXNAME}.system"
    sudo ./result/sw/bin/darwin-rebuild switch --flake ".#${NIXNAME}"
    ;;
  *) "${root}/_scripts/nix_switch.sh" ;;
esac
