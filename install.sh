#!/usr/bin/env bash

# Ensure $HOME/.config exists
mkdir -p "$HOME/.config"

# Create SOPS age key
sops_age_dir="sops/age"
if [[ ! -d ${sops_age_dir} ]]; then
	mkdir -p "${sops_age_dir}"
	age-keygen -o "${sops_age_dir}/keys.txt" || true
	echo "*" >>"${sops_age_dir}/.gitignore"
fi

stow .
