# Writes one sesh session per git worktree found under the given roots.
#
#   sesh-worktrees OUT ROOT...
#
# Each repo is keyed by its common git dir, so a bare repo and the worktrees
# checked out inside it count once however many of them `find` turns up. The
# session is named <repo>/<worktree>, where <worktree> is the checkout's path
# inside the repo's container (feat/jq-tasks), or just <repo> for a plain clone.
#
# The file is replaced atomically and always exists afterwards, because sesh
# refuses to start at all when an imported config is missing.

out=$1
shift

tmp=$(mktemp "${out}.XXXXXX")
trap 'rm -f "$tmp"' EXIT

# TOML basic strings: escape backslashes, then quotes.
toml() {
  local s=${1//\\/\\\\}
  printf '"%s"' "${s//\"/\\\"}"
}

# tmux rejects . and : in session names.
session_name() {
  local s=${1//./_}
  printf '%s' "${s//:/_}"
}

declare -A seen=()

emit_repo() {
  local common=$1 container repo path rel
  case $common in
    */.bare | */.git) container=${common%/*} ;;
    *) container=$common ;;
  esac
  repo=${container##*/}
  repo=${repo%.git}

  while IFS= read -r line; do
    case $line in
      "worktree "*) path=${line#worktree } ;;
      bare) path= ;;
      "")
        if [[ -n ${path:-} && -d $path ]]; then
          if [[ $path == "$container" ]]; then
            rel=
          elif [[ $path == "$container"/* ]]; then
            rel=${path#"$container"/}
          else
            rel=${path##*/}
          fi
          {
            printf '[[session]]\n'
            printf 'name = %s\n' "$(toml "$(session_name "$repo${rel:+/$rel}")")"
            printf 'path = %s\n' "$(toml "$path")"
            printf 'startup_command = "clear"\n\n'
          } >>"$tmp"
        fi
        path=
        ;;
    esac
  done < <(
    git -C "$common" worktree list --porcelain 2>/dev/null
    echo
  )
}

for root in "$@"; do
  [[ -d $root ]] || continue
  # Repos sit at most a client folder deep (Harambee/<repo>.git), and worktree
  # checkouts are never descended into: a .git inside one is pruned with it.
  while IFS= read -r -d '' candidate; do
    # A worktree's .git is a file, and git -C wants a directory.
    [[ -f $candidate ]] && candidate=${candidate%/*}
    common=$(git -C "$candidate" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || continue
    [[ -n ${seen[$common]:-} ]] && continue
    seen[$common]=1
    emit_repo "$common"
  done < <(find "$root" -maxdepth 3 \
    \( -name node_modules -o -name .venv -o -name .devbox \) -prune \
    -o \( -name '*.git' -o -name .bare -o -name .git \) -print0 -prune)
done

mv "$tmp" "$out"
trap - EXIT
