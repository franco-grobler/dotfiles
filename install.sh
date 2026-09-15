#!/usr/bin/env bash
# One-time bootstrap. Everything else lives in nix/ and is applied with
# `just nix-switch`.
set -euo pipefail

# Create SOPS age key
sops_age_dir="sops/age"
if [[ ! -d ${sops_age_dir} ]]; then
	mkdir -p "${sops_age_dir}"
	age-keygen -o "${sops_age_dir}/keys.txt" || true
	echo "*" >>"${sops_age_dir}/.gitignore"
fi

# Neovim is the only config still managed by stow; lazy.nvim owns its own
# plugin lockfile, so home-manager stays out of the way.
for dir in nvim nvim-dev nvim-prime; do
	[[ -d ${dir} ]] && stow "${dir}"
done
