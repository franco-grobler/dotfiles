#!/usr/bin/env bash

# Create SOPS age key
sops_age_dir="sops/age"
if [[ ! -d ${sops_age_dir} ]]; then
	mkdir -p "${sops_age_dir}"
	age-keygen -o "${sops_age_dir}/keys.txt" || true
	echo "*" >>"${sops_age_dir}/.gitignore"
fi

mkdir -p "$HOME/.config"

stow .
