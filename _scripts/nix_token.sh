#!/usr/bin/env bash
# Raises nix's GitHub fetch rate limit, once per machine.
#
# Usage: nix_token.sh <op:// reference to the token>
#
# Written to the user's nix.conf, outside the repo, so it is never committed.
set -euo pipefail
item="${1:?usage: nix_token.sh <op://reference>}"

command -v op >/dev/null || {
  echo "1Password CLI not found" >&2
  exit 1
}
conf="${XDG_CONFIG_HOME:-$HOME/.config}/nix/nix.conf"
mkdir -p "$(dirname "$conf")"
umask 077
printf 'access-tokens = github.com=%s\n' "$(op read "${item}")" >"$conf"
echo "wrote $conf"
nix config show access-tokens | sed 's/=.*/= <set>/'
