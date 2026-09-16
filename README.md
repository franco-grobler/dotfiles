# Dotfiles

Nix owns almost everything here. `nix/` is a [dendritic] flake-parts
configuration covering three machines — a personal MacBook Air, a work MacBook,
and a linux desktop — that share as much or as little as each one needs. See
[`nix/README.md`](nix/README.md) for the architecture.

[dendritic]: https://github.com/mightyiam/dendritic

## Install

```bash
direnv allow      # dev shell: installs the git hooks, puts the tooling on PATH
just nix-switch   # build and activate this machine's configuration
```

The neovim config is symlinked into `~/.config` by the switch itself, so there
is no separate bootstrap script to remember.

On a machine that has never had nix-darwin or nixos-rebuild, use
`just nix-bootstrap` for the first activation instead.

## Layout

| Path                                        | Contents                                                       |
| ------------------------------------------- | -------------------------------------------------------------- |
| `nix/modules/home/`                         | home-manager modules, grouped by what they do                  |
| `nix/modules/darwin/`, `nix/modules/nixos/` | system modules, incl. `hosts/`                                 |
| `nix/modules/flake/`                        | the plumbing that discovers the tree                           |
| `nvim/`                                     | neovim config, symlinked live into `~/.config` by home-manager |
| `_scripts/`, `justfile`                     | host resolution and the task runner                            |
| `Credentials.md`                            | where secrets live (1Password; nothing secret is committed)    |

## Checks

`nix flake check` builds every host that belongs to the current system, plus
the lints, and is what CI runs on both linux and macOS. `nix fmt` formats the
whole repo -- nix, shell, lua, and the workflows.

A program that ships config files is a folder holding both — e.g.
`nix/modules/home/terminal/tmux/{default.nix,tmux.reset.conf}`.
