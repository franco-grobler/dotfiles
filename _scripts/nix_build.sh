#!/usr/bin/env bash
# Builds this host's configuration without activating it.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "${root}/_scripts/set_nix_envs.sh"
cd "${root}/nix"

case "${NIXCONFIG}" in
  darwinConfigurations) nix build ".#${NIXCONFIG}.${NIXNAME}.system" ;;
  nixosConfigurations) nix build ".#${NIXCONFIG}.${NIXNAME}.config.system.build.toplevel" ;;
  homeConfigurations) nix build ".#${NIXCONFIG}.${NIXNAME}.activationPackage" ;;
esac
