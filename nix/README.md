# Nix configuration

Nothing is listed anywhere. The tree *is* the configuration: files are
discovered by `modules/flake/leaves.nix`, and where a file sits determines what
it is called.

```
modules/
├── home/      plain home-manager modules  →  flake.modules.homeManager.*
├── darwin/    plain nix-darwin modules    →  flake.modules.darwin.*
├── nixos/     plain NixOS modules         →  flake.modules.nixos.*
└── flake/     the plumbing (flake-parts modules)
```

## Writing a module

A leaf is an ordinary module. No wrapper, no `flake.modules.…` line — you could
paste it straight out of the home-manager manual:

```nix
# modules/home/vcs/lazygit/default.nix
{ pkgs, ... }:
{
  home.packages = [ pkgs.lazygit ];
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
```

That file *is* `flake.modules.homeManager.lazygit`.

A program that ships config files gets a folder of its own, so the module and
its files travel together and the files keep their natural names:

```
vcs/
├── default.nix          the `vcs` group
├── git.nix              no config files → one file
├── jujutsu.nix
├── gh/
│   ├── default.nix
│   ├── config.yml
│   └── hosts.yml
├── git-cliff/{default.nix, cliff.toml}
└── lazygit/{default.nix, config.yml}
```

## Naming

| Path                             | Aggregate                      |
| -------------------------------- | ------------------------------ |
| `home/vcs/git.nix`               | `homeManager.git`              |
| `home/vcs/lazygit/default.nix`   | `homeManager.lazygit`          |
| `home/vcs/default.nix`           | `homeManager.vcs`              |
| `home/base.nix`                  | `homeManager.base`             |
| `darwin/hosts/CSLGPKPMH9Y4X.nix` | `darwin."hosts/CSLGPKPMH9Y4X"` |

**A file is named after itself, wherever it sits.** Folders are for reading, not
for naming — moving `lazygit.nix` from `vcs/` to `code/` changes nothing. Two
exceptions earn their keep:

- `default.nix` is named after its folder. That is what makes a folder work both
  ways: as a group of programs (`vcs/`) and as one program plus its config files
  (`vcs/lazygit/`).
- anything under `hosts/` keeps the prefix, so `configurations.nix` can find it.

Names share one namespace per class, so the loader throws if two files claim the
same one.

## Referring to other modules

Every module gets `features` — the aggregates of its own class — as an argument.
A folder's `default.nix` is therefore just a list:

```nix
# modules/home/monitor/default.nix
{ features, ... }:
{
  imports = with features; [
    btop
    htop
    fastfetch
  ];
}
```

Host modules also get `home` (the home-manager aggregates) and `mkPkgs`.

## The tree

```
home/
├── base.nix            core + shell — what every machine gets
├── dev.nix             vcs + code + ai + container
├── core/               xdg locale fonts unix-tools bat glow nh gpg ssh
│                       nix-tools repo state-version
├── shell/              zsh bash nushell shell-aliases starship atuin carapace
│                       direnv just zoxide
├── terminal/           ghostty alacritty tmux tmuxinator sesh
├── vcs/                git gh lazygit git-cliff jujutsu
├── code/               neovim languages atlas pnpm octave posting lazysql
│   └── languages/      go python nix lua sh web tex markdown docker dlv misc
├── ai/                 claude opencode cursor-cli
├── container/          colima lazydocker
├── monitor/            btop htop fastfetch
├── desktop/            hyprland hypridle hyprlock hyprpaper waybar rofi mako
│                       walker omarchy theme browsers gui-apps wallpapers
│                       pointer xresources                  (linux only)
└── profile/            personal work

darwin/                 base homebrew users home-manager
├── system/             nix-daemon locale macos-defaults touch-id
├── profile/            personal
└── hosts/              Francos-MacBook-Air CSLGPKPMH9Y4X

nixos/                  base users home-manager docker networking ssh
├── system/             nix-daemon locale
├── desktop/            hyprland greetd audio chrome
└── hosts/              nixos-x8664
```

Every folder with a `default.nix` is importable as one name; every file inside
it is importable on its own. That is the whole reuse story.

## Hosts

A host file is a flat inventory of what the machine is made of:

```nix
# modules/darwin/hosts/CSLGPKPMH9Y4X.nix
{
  features,
  home,
  mkPkgs,
  ...
}:
{
  imports = with features; [
    base
    work
  ];

  nixpkgs.pkgs = mkPkgs {
    system = "aarch64-darwin";
    channel = "stable";
  };

  dotfiles.users."franco.grobler" = {
    description = "Franco Grobler";
    modules = with home; [
      base
      dev
      terminal
      work
    ];
  };
}
```

`dotfiles.users` is the only place a username appears. The account, the
home-manager hand-off, `trusted-users`, `system.primaryUser` and group
membership all follow from it, so adding a host or a second person is a
declaration rather than a grep. See `darwin/users.nix`.

| Host                  | Class  | Takes                                                              |
| --------------------- | ------ | ------------------------------------------------------------------ |
| `Francos-MacBook-Air` | darwin | base, dev, terminal, monitor, **personal**                         |
| `CSLGPKPMH9Y4X`       | darwin | base, dev, terminal, **work** — no `monitor`, no personal identity |
| `nixos-x8664`         | nixos  | base, dev, terminal, monitor, **desktop**, **personal**            |

The filename is the configuration name, so `darwin-rebuild switch --flake .`
resolves by hostname. Stand-alone home-manager outputs exist too:
`homeConfigurations."francogrobler@nixos-x8664"` and `…@CSLGPKPMH9Y4X`.

## Adding things

- **A program** — one file in the group it belongs to, or a folder with a
  `default.nix` if it ships config files. Add its name to the group's
  `default.nix`, or straight to a host.
- **A group** — a new folder with a `default.nix`.
- **A host** — one file in `hosts/`. There is no builder to edit.

## Channels

`modules/flake/channels.nix` builds each host's `pkgs`. Every host gets both
channels regardless of which it is based on:

- `pkgs.foo` — the host's base channel
- `pkgs.unstable.foo` — always `nixpkgs-unstable`
- `pkgs.stable.foo` — always the pinned release

A cherry-pick list (`atlas`, `direnv`, `gh`, `neovim`, `opencode`, `panache`,
`posting`, `uv`) is promoted from unstable to the top level on stable-based
hosts, so modules never have to know which channel their host runs.

All three hosts are based on the pinned release, because nix-darwin asserts that
nixpkgs' release matches its own branch. To base a host on unstable, move
`nix-darwin` and `home-manager` to their `master` branches first.

## Plumbing

`modules/flake/` is the only place flake-parts modules live, and the only place
`flake.modules` is mentioned.

| File                      | Role                                                                         |
| ------------------------- | ---------------------------------------------------------------------------- |
| `leaves.nix`              | walks the tree and turns paths into aggregates                               |
| `module-classes.nix`      | declares `flake.modules.<class>.<name>` as a lazy option tree                |
| `channels.nix`            | provides the `mkPkgs` argument                                               |
| `configurations.nix`      | `hosts/*` → `darwinConfigurations` / `nixosConfigurations`                   |
| `home-configurations.nix` | stand-alone home-manager outputs                                             |
| `systems.nix`             | which systems `perSystem` outputs are built for                              |
| `formatter.nix`           | `nix fmt` for the whole repo, not just the nix tree                          |
| `checks.nix`              | re-exposes every host as a `checks` output, so `nix flake check` builds them |
| `lints.nix`               | statix + deadnix as a `checks` output, so CI gates on them                   |
| `dev-shell.nix`           | `nix develop`: installs the git hooks, and the tools they call               |

## Day to day

```bash
just nix-target # which output does this machine resolve to?
just nix-build  # build it, don't activate
just nix-switch # activate
just nix-check  # evaluate all three hosts
just nix-update # refresh flake.lock
```

On the linux host, `just nix-hardware` regenerates its
`hardware-configuration.nix` in place from `nixos-generate-config`. Pass the
host explicitly on a fresh install, before the hostname matches the flake
attribute: `just nix-hardware nixos-x8664`.

## Secrets

1Password is the store. The ssh agent, `op-ssh-sign` for git signing and
`op read` for anything else. Nothing secret is committed and there is no
sops/age key to carry between machines.

To add a secret, reference it by `op://` URI and read it at the point of use:

```nix
home.sessionVariables.SOME_API_KEY = "op://Personal/Some Service/credential";
home.shellAliases.some-cli = "SOME_API_KEY=$(op read $SOME_API_KEY) some-cli";
```

## What nix does not manage

The neovim *configuration*. `code/neovim.nix` points `~/.config/nvim` at the
working copy with `mkOutOfStoreSymlink` rather than copying it into the store,
so edits are live and lazy.nvim can write its own plugin lockfile. The symlink
itself is made by `switch`, so there is no bootstrap script to run on a fresh
machine.
