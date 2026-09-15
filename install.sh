#!/usr/bin/env bash
# One-time bootstrap. Everything else lives in nix/ and is applied with
# `just nix-switch`.
set -euo pipefail

# Neovim is the only config not managed by home-manager: lazy.nvim owns its own
# plugin lockfile and does not want nix in the way.
for dir in nvim nvim-dev nvim-prime; do
	[[ -d ${dir} ]] || continue
	ln -sfn "${PWD}/${dir}" "${HOME}/.config/${dir}"
	echo "linked ~/.config/${dir}"
done
