#!/usr/bin/env bash
# Writes the public half of every 1Password SSH key to ~/.ssh/<host>/key.pub.
#
# A key's hosts are its item's URLs (github.com, ssh://git@bamboo, ...). Only
# the vaults the 1Password agent serves are read -- ssh can't use a key the
# agent won't sign with. Per profile, in nix (see nix/modules/home/core/ssh/):
#
#   dotfiles.ssh.keys    host -> key. Wins over whatever 1Password says, and
#                        adds hosts no item has a URL for (aliases).
#   dotfiles.ssh.ignore  item ids, item titles or hosts to leave alone.
#
# Two different keys on one host with no override is an error: that host is
# left as it was and the run fails, naming the items.
#
# Run once per machine, and again after adding a key. Only public halves are
# written; ssh hands them to the agent, which signs with the private half that
# never leaves 1Password.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "${root}/_scripts/set_nix_envs.sh"
cd "${root}/nix"

case "${NIXCONFIG}" in
  nixosConfigurations | darwinConfigurations) home="${USER}@${NIXNAME}" ;;
  *) home="${NIXNAME}" ;;
esac
ref=".#homeConfigurations.\"${home}\""
cfg=$(nix eval --json --apply 'h: { inherit (h.config.dotfiles.ssh) keys ignore; }' "$ref")
vaults=$(sed -n 's/^vault *= *"\(.*\)"$/\1/p' "${root}/nix/modules/home/core/ssh/agent.toml")

ignored() { jq -e --arg v "$1" '.ignore | index($v) != null' <<<"$cfg" >/dev/null; }

# Key type and material only, so the same key saved twice with different
# comments isn't a conflict.
material() { awk '{ print $1 " " $2 }' <<<"$1"; }

# ssh://git@bamboo:22/x -> bamboo
host_of() {
  sed -E 's#^[A-Za-z][A-Za-z0-9+.-]*://##; s#^[^@/]*@##; s#[/?\#].*$##; s#:[0-9]*$##' <<<"$1" |
    tr '[:upper:]' '[:lower:]'
}

declare -A key=() from=() conflict=()

claim() {
  local host=$1 pub=$2 src=$3
  if [[ -z $host ]] || ignored "$host"; then
    return 0
  fi
  if [[ -z ${key[$host]:-} ]]; then
    key[$host]=$pub
    from[$host]=$src
  else
    [[ ${key[$host]} == "$pub" ]] || conflict[$host]=1
    from[$host]+=", $src"
  fi
}

items=$(
  for vault in $vaults; do
    op item list --categories "SSH Key" --vault "$vault" --format json </dev/null |
      jq -r '.[] | [.vault.id, .id, .title, ([.urls[]?.href] | join(" "))] | @tsv'
  done
)

while IFS=$'\t' read -r vault id title hrefs; do
  [[ -n $id ]] || continue
  if ignored "$id" || ignored "$title"; then
    echo "skip $title (ignored)"
    continue
  fi
  if [[ -z $hrefs ]]; then
    echo "skip $title (no URL)"
    continue
  fi
  pub=$(material "$(op read "op://${vault}/${id}/public key" </dev/null)")
  for href in $hrefs; do
    claim "$(host_of "$href")" "$pub" "$title"
  done
done <<<"$items"

# Overrides last: they replace whatever 1Password claimed, conflicts included.
while IFS=$'\t' read -r host src; do
  case "$src" in
    op://*) pub=$(op read "${src}/public key" </dev/null) ;;
    *) pub=$src ;;
  esac
  key[$host]=$(material "$pub")
  from[$host]="dotfiles.ssh.keys"
  unset 'conflict[$host]'
done < <(jq -r '.keys | to_entries[] | [.key, .value] | @tsv' <<<"$cfg")

failed=0
while IFS= read -r host; do
  [[ -n $host ]] || continue
  if [[ -n ${conflict[$host]:-} ]]; then
    echo "conflict $host: ${from[$host]} -- pin one with dotfiles.ssh.keys.\"$host\", or ignore the others" >&2
    failed=1
    continue
  fi
  dst="$HOME/.ssh/${host}/key.pub"
  mkdir -p -m 700 "$(dirname "$dst")"
  printf '%s\n' "${key[$host]}" >"$dst"
  chmod 600 "$dst"
  echo "wrote $dst (${from[$host]})"
done < <(printf '%s\n' "${!key[@]}" | sort)

exit "$failed"
