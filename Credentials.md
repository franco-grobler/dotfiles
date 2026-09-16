# Credentials

1Password is the store for everything secret. Nothing sensitive is committed,
and there is no age or gpg key to carry between machines.

| What                 | Where                                     | Used by             |
| -------------------- | ----------------------------------------- | ------------------- |
| git commit signing   | 1Password ssh key, via `op-ssh-sign`      | `home/vcs/git.nix`  |
| ssh auth             | 1Password ssh agent                       | `home/core/ssh.nix` |
| GitHub token for nix | `op://Personal/Nix GitHub PAT/credential` | `just nix-token`    |

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

## The linux host

Everything above is 1Password, which works because the two macs run the
1Password desktop app and get its ssh agent and `op-ssh-sign` for free. The
linux desktop has no such story: it can read an `op://` URI with the CLI, but
it has nothing to unlock the CLI with at boot, so a secret that has to exist
_before_ a human logs in -- a wifi PSK, a service token, a borg passphrase --
has nowhere to live today.

Nothing currently needs one, which is why no key management is set up. When
something does, the decision to make is between:

- **[sops-nix]** -- secrets encrypted in this repo, decrypted at activation with
  the host's own ssh host key. No new key to carry: the key is already on the
  machine. This is the one to reach for first.
- **[agenix]** -- the same shape, age instead of sops. Simpler, fewer features.

Both mean committing ciphertext here, which is a change from the current "nothing
secret is committed at all" rule -- worth making deliberately rather than at the
moment something is needed.

[sops-nix]: https://github.com/Mic92/sops-nix
[agenix]: https://github.com/ryantm/agenix
