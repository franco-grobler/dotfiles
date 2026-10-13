#!/usr/bin/env bash
# Writes each ssh host's public key to ~/.ssh/<host>/key.pub (dotfiles.ssh.keys).
#
# Run once per machine, and again after adding a key. Only public halves are
# written; ssh hands them to the 1Password agent, which signs with the private
# half that never leaves 1Password. See nix/modules/home/core/ssh/.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "${root}/_scripts/set_nix_envs.sh"
cd "${root}/nix"

case "${NIXCONFIG}" in
  nixosConfigurations | darwinConfigurations) home="${USER}@${NIXNAME}" ;;
  *) home="${NIXNAME}" ;;
esac
ref=".#homeConfigurations.\"${home}\""
keys=$(nix eval --json --apply 'h: h.config.dotfiles.ssh.keys' "$ref")
jq -r 'to_entries[] | [.key, .value] | @tsv' <<<"$keys" |
  while IFS=$'\t' read -r host src; do
    case "$src" in
      op://*) key=$(op read "${src}/public key" </dev/null) ;;
      *) key="$src" ;;
    esac
    dst="$HOME/.ssh/${host}/key.pub"
    mkdir -p -m 700 "$(dirname "$dst")"
    printf '%s\n' "$key" >"$dst"
    chmod 600 "$dst"
    echo "wrote $dst"
  done
