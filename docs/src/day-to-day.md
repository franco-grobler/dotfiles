# Day to day

Run these from the repo root. `just` with no arguments lists them all.

| Recipe                   | What it does                                                        |
| ------------------------ | ------------------------------------------------------------------- |
| `just nix-target`        | Shows which flake output this machine resolves to                   |
| `just nix-build`         | Builds this host without activating it                              |
| `just nix-test`          | Dry run: builds and runs activation checks (`darwin-rebuild check`) |
| `just nix-switch`        | Activates this host's configuration                                 |
| `just nix-upgrade-check` | Checks whether a newer Determinate Nix is available                 |
| `just nix-check`         | `nix flake check`: builds every host, plus statix and deadnix       |
| `just nix-fmt`           | Formats the whole repo with treefmt                                 |
| `just nix-update`        | Updates brew and mas, refreshes `flake.lock` and commits it         |
| `just ssh-keys`          | Writes each SSH host's public key to `~/.ssh/<host>/key.pub`        |
| `just nix-token`         | Puts a GitHub token in your user `nix.conf`                         |
| `just docs`              | Serves this book with live reload                                   |

Nix itself is not covered by `nix-update`; see [Updating Determinate
Nix](determinate-nix.md).

CI also opens a weekly pull request that bumps `flake.lock`, and it only merges
once every host still evaluates.

## Secrets

Nothing secret is committed. Refer to a secret by its `op://` URI and read it
where it is used:

```nix
home.sessionVariables.SOME_API_KEY = "op://Personal/Some Service/credential";
home.shellAliases.some-cli = "SOME_API_KEY=$(op read $SOME_API_KEY) some-cli";
```
