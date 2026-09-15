# Dotfiles

Nix owns almost everything here. `nix/` is a [dendritic] flake-parts
configuration covering three machines — a personal MacBook Air, a work MacBook,
and a linux desktop — that share as much or as little as each one needs. See
[`nix/README.md`](nix/README.md) for the architecture.

[dendritic]: https://github.com/mightyiam/dendritic

## Install

```bash
./install.sh      # symlink the neovim config into ~/.config
just nix-switch   # build and activate this machine's configuration
```

On a machine that has never had nix-darwin or nixos-rebuild, use
`just nix-bootstrap` for the first activation instead.

## Layout

| Path | Contents |
| --- | --- |
| `nix/modules/home/` | home-manager modules, grouped by what they do |
| `nix/modules/darwin/`, `nix/modules/nixos/` | system modules, incl. `hosts/` |
| `nix/modules/flake/` | the plumbing that discovers the tree |
| `nvim/` | neovim config, symlinked by `install.sh` rather than home-manager |
| `_scripts/`, `justfile` | host resolution and the task runner |
| `Credentials.md` | where secrets live (1Password; nothing secret is committed) |

A program that ships config files is a folder holding both — e.g.
`nix/modules/home/terminal/tmux/{default.nix,tmux.reset.conf}`.
