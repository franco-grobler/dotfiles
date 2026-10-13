# Bootstrap

On a fresh Mac, `darwin-rebuild` and `just` are not installed yet. `nix run`
provides `just` for the first run, and the `nix-bootstrap` recipe builds the
system and runs the `darwin-rebuild` it just built.

```bash
cd ~/dotfiles

# Check which configuration this machine resolves to.
nix run nixpkgs#just -- nix-target

# Optional, but recommended: raises nix's GitHub API rate limit. Reads a token
# from 1Password and writes it to ~/.config/nix/nix.conf, outside the repo.
nix run nixpkgs#just -- nix-token

# Build and activate.
nix run nixpkgs#just -- nix-bootstrap
```

`nix-target` should print `darwinConfigurations.<your host>`. If it does not, go
back to [Before you start](prerequisites.md#1-the-machine-needs-a-host-file).

## Expect the first switch to stop on `/etc/nix/nix.custom.conf`

The Determinate installer writes `/etc/nix/nix.custom.conf`. nix-darwin will not
replace an `/etc` file it does not recognise, so on a new Mac activation aborts
with **"Unexpected files in /etc"**.

To fix it, add the file's hash to `knownSha256Hashes` in
`nix/modules/darwin/system/nix-daemon.nix`:

```bash
shasum -a 256 /etc/nix/nix.custom.conf
```

```nix
knownSha256Hashes = [
  # Francos-MacBook-Air
  "afae59aee64e05709962ccbeef2efd48c6cbc80f4e65fce03f0a05c303914959"
  # <new host>
  "<the hash you just printed>"
];
```

Then run `nix-bootstrap` again. nix-darwin keeps the original as
`nix.custom.conf.before-nix-darwin`.

## Existing dotfiles

home-manager will not overwrite a file it does not own. It renames the file to
`<name>.backup` (`backupFileExtension = "backup"`) and puts its own in place. On
a Mac that ran an earlier setup, look for leftovers once the switch is done:

```bash
find ~ -maxdepth 3 -name '*.backup' 2>/dev/null
```

Check what is in them, copy anything worth keeping into the repo, and delete
them.

## Links left by the old stow setup

The old setup used stow to link whole folders into `~/.config`, such as
`~/.config/alacritty -> ../dotfiles/alacritty`. Those folders have moved under
`nix/modules/home/`, so the links are broken, and home-manager can't create its
own files in their place ("mkdir: cannot create directory").

Every switch removes these first (`nix/modules/home/core/stow-links.nix`). It
only removes links that are broken *and* point into the dotfiles checkout. Stow
links that still work are left alone; `just stow-clean` lists them and removes
them once you confirm.
