# Before you start

The flake handles almost everything, but a few things have to be on the machine
before it can run, and nix-darwin will not install them.

## 1. The machine needs a host file

Each Mac is a file in `nix/modules/darwin/hosts/`, and **the file's name is the
configuration name**. `_scripts/set_nix_envs.sh` picks the configuration from
the Mac's own hostname:

```bash
scutil --get LocalHostName
```

If no host file matches that name, either add or rename one (see [Adding a
host](#adding-a-host)) or override the lookup for each command with
`NIXNAME=<host> just …`.

## 2. The account name must match

The host declares its user in `dotfiles.users`, and nix-darwin manages that
account. Check that `whoami` returns the same name:

| Host                  | Account          |
| --------------------- | ---------------- |
| `Francos-MacBook-Air` | `francogrobler`  |
| `CSLGPKPMH9Y4X`       | `franco.grobler` |

## 3. Install Determinate Nix

`darwin/system/nix-daemon.nix` sets `nix.enable = false`: Determinate owns the
daemon and `/etc/nix/nix.conf`, and nix-darwin only manages
`/etc/nix/nix.custom.conf`. Install it with the [Determinate
installer](https://docs.determinate.systems/), then open a new shell and check
that `nix --version` works.

## 4. Install Homebrew

nix-darwin's `homebrew` module drives `brew` but does not install it. Install it
from [brew.sh](https://brew.sh).

On a personal Mac, sign in to the **App Store** as well:
`profile/personal/default.nix` installs App Store apps through `mas`, which
needs a signed-in account. The work Mac has the App Store disabled, so nothing
it gets comes from there.

## 5. Install and set up 1Password

1Password stores every secret: the SSH agent, git commit signing (`op-ssh-sign`)
and `op read`. Before bootstrapping:

1. Install the 1Password app **into `/Applications`**. Git's signer is hardcoded
   to `/Applications/1Password.app/Contents/MacOS/op-ssh-sign`
   (`nix/modules/home/vcs/git.nix`), but the brew casks install into
   `~/Applications`. Install 1Password by hand first, and after the switch check
   that `/Applications/1Password.app` is still the copy you use.
2. Sign in to every account you need.
3. In **Settings → Developer**, turn on **Use the SSH agent** and **Integrate
   with 1Password CLI**.
4. Make sure the host's SSH keys are in a vault the agent serves.
   `nix/modules/home/core/ssh/agent.toml` only offers keys from the **Private**
   and **Homelab** vaults.

## 6. Clone the repo to `~/dotfiles`

`dotfiles.root` defaults to `~/dotfiles`. Neovim, Claude and colima configs
symlink back into the working copy, so the clone has to be there. SSH is not set
up yet, so clone over HTTPS:

```bash
git clone https://github.com/franco-grobler/dotfiles.git ~/dotfiles
```

Switch the remote to SSH [after the first switch](after-switch.md).

## Adding a host

A new Mac is one file. Copy the closest existing host in
`nix/modules/darwin/hosts/`, name it after the machine's `LocalHostName`, and
change `dotfiles.users` and the module list. Nothing else needs editing:
`configurations.nix` picks it up, and `home-configurations.nix` derives a
stand-alone `homeConfigurations."<user>@<host>"` from it.
