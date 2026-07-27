# Credentials rotation

## Leaked: GitHub Personal Access Token in git history

`nix/nix.conf` historically contained:

    access-tokens = github.com=XX

This file was committed to the repository. The token must be treated as
compromised regardless of later edits — it remains recoverable from git
history until scrubbed.

## Step 1: Revoke the token (DO THIS FIRST)

1. Open <https://github.com/settings/tokens>
2. Find the token starting with `github_pat_**` and delete it.
3. If you cannot identify it, revoke all Fine-grained PATs and recreate as
   needed.

## Step 2: Create a replacement token

1. Generate a new fine-grained PAT at
   <https://github.com/settings/personal-access-tokens/new>
   with the minimum scopes required by `nix flake` fetches
   (typically `Contents: Read` on the repos you pull from via
   `github:` flakes).
2. Store it in 1Password as "Nix GitHub PAT".
3. Reference it via the 1Password CLI in shell, e.g.:
   export NIX_GITHUB_PAT="$(op read 'op://Personal/Nix GitHub PAT/credential')"

## Step 3: Stop committing the token

Remove the `access-tokens =` line from `nix/nix.conf`. Two options for ongoing
auth:

A. Per-user nix conf (RECOMMENDED): write the token to
`~/.config/nix/nix.conf` (NOT in the repo), e.g.:
access-tokens = github.com=github*pat*<NEW>
`nix.conf` in the repo then only carries the
`experimental-features` / substituters / trusted-public-keys lines.

B. Use `gh auth setup-git` to populate `~/.config/git/credentials` — avoids
nix.conf entirely.

## Step 4: Scrub history (REQUIRED — token is still in old commits)

The token remains readable from git history even after deletion. After
Step 1, history scrubbing is non-urgent but recommended for hygiene.

git-filter-repo approach:

    # back up first
    cp -R . ../dotfiles.bak
    pipx install git-filter-repo
    git filter-repo --replace-text <(echo \
      '')

Then force-push (coordinate with any collaborators first):
git push --force-with-lease origin main

Anyone with a clone must re-clone after force-push; a `git pull` will NOT
remove the token from local history.

## Step 5: Verify

    git log --all -p | grep 'github_pat_'   # should output nothing

## Other secrets to audit

- `nix/users/francogrobler/programs/vsc.nix` contains an `ssh-rsa` signing
  key in plaintext. SSH public keys are not secrets, but confirm it is the
  PUBLIC half only (it is — `ssh-rsa AAAA…`). No action needed.
- `sops/age/keys.txt` is correctly gitignored. Confirm `sops/age/.gitignore`
  covers it (install.sh writes `*` there).
