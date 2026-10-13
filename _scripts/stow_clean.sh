#!/usr/bin/env bash
# Removes symlinks left in ~/.config by the old stow setup.
#
# `stow -D` can't do this from this branch: it works out what to unlink from
# the package's own files, and the old top-level folders (and .stowrc) are
# gone. Instead, match the links themselves. Stow's are relative
# (../dotfiles/...); home-manager's are absolute (/nix/store/...), so only
# stow's match.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
name="$(basename "${root}")"

links=$(find "$HOME/.config" -maxdepth 4 -type l -lname "../*${name}/*" 2>/dev/null || true)
if [[ -z ${links} ]]; then
  echo "no stow links left"
  exit 0
fi

while IFS= read -r l; do
  printf '%s -> %s\n' "${l/#"$HOME"/\~}" "$(readlink "$l")"
done <<<"$links"

read -rp "Remove these links? (the files they point at are untouched) [y/N] " ok
[[ ${ok} == [yY] ]] || exit 0
while IFS= read -r l; do rm -- "$l"; done <<<"$links"
echo "removed $(wc -l <<<"$links" | tr -d ' ') links"
