# Credentials

1Password is the store for everything secret. Nothing sensitive is committed,
and there is no age or gpg key to carry between machines.

| What | Where | Used by |
| --- | --- | --- |
| git commit signing | 1Password ssh key, via `op-ssh-sign` | `home/vcs/git.nix` |
| ssh auth | 1Password ssh agent | `home/core/ssh.nix` |
| GitHub token for nix | `op://Personal/Nix GitHub PAT/credential` | `just nix-token` |

To reference a secret from a module, point at it by `op://` URI and read it at
the point of use rather than baking in the value:

```nix
home.sessionVariables.SOME_API_KEY = "op://Personal/Some Service/credential";
home.shellAliases.some-cli = "SOME_API_KEY=$(op read $SOME_API_KEY) some-cli";
```

## The nix GitHub token

Optional. It exists only to raise GitHub's fetch rate limit during
`nix flake update`, so it wants **no permissions at all** — a fine-grained PAT
with every scope left unchecked is correct and sufficient.

```bash
just nix-token                                  # reads the default item
just nix-token 'op://Work/Nix GitHub PAT/credential'   # or point it elsewhere
```

That writes `~/.config/nix/nix.conf`, which is outside this repo. It is not
managed by home-manager, so it survives `nix-switch` and has to be run once per
machine.

## A note on the token in git history

An earlier `nix/nix.conf` committed an `access-tokens` line. That token had zero
permissions — it only ever raised a rate limit — so it was deliberately not
rotated and the history has not been rewritten. Do not read its presence as an
outstanding incident.
