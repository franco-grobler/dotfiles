#!/usr/bin/env bash
# Checks whether a newer Determinate Nix is available. Never upgrades.
#
# Exits 0 when up to date (or when Determinate Nix isn't installed, as on the
# NixOS host), and 1 when behind, so it can gate a script. See
# docs/src/determinate-nix.md.
#
# Compares the version lines rather than grepping the notice: its wording has
# changed before ("is now available" became "is available"), which silently
# turned the old check off.
set -euo pipefail

if ! command -v determinate-nixd &>/dev/null; then
  echo "determinate-nixd not found -- this machine doesn't run Determinate Nix"
  exit 0
fi

version=$(determinate-nixd version 2>/dev/null || true)
running=$(sed -n 's/^Determinate Nixd daemon version: //p' <<<"${version}")
latest=$(sed -n 's/^Latest version: //p' <<<"${version}")

if [ -z "${latest}" ]; then
  echo "Determinate Nix ${running:-(unknown version)}; couldn't fetch the latest version"
  exit 0
fi

if [ "${running}" = "${latest}" ]; then
  echo "Determinate Nix ${running} is up to date"
  exit 0
fi

echo "Determinate Nix ${latest} is available (running ${running:-unknown})."
echo "Upgrade with: sudo determinate-nixd upgrade -- see docs/src/determinate-nix.md"
exit 1
