# The work MacBook

The work Mac follows the same steps as any other Mac. This page covers only what
is different.

## What it gets

`nix/modules/darwin/hosts/CSLGPKPMH9Y4X.nix`:

- **Account**: `franco.grobler`. The personal hosts use `francogrobler`.
- **Home modules**: `base`, `dev`, `terminal`, `work`. It leaves out `monitor`
  and the personal identity.
- **System modules**: `base` and `work`. `darwin/profile/work.nix` adds its
  brews and casks on top of the baseline in `darwin/homebrew.nix`.
- **No App Store apps**: the App Store is disabled on this Mac, so `mas` and
  every `masApps` entry live in `darwin/profile/personal.nix`. Use a cask
  instead where one exists. The WireGuard CLI (`wg`, `wg-quick`) still comes
  from nix on every host.

`nix/modules/home/profile/work.nix` adds:

- the Cloudsmiths commit email and its own SSH signing key, which is also the
  github.com auth key;
- `awscli2`, `google-cloud-sdk`, `kubectl` and `kubernetes-helm`;
- an empty `dotfiles.sessions`, for work tmuxinator layouts still to be added.

## Checklist

### In the repo

- [x] Name the host file after the Mac's `LocalHostName` (`CSLGPKPMH9Y4X`).
- [x] Add `darwin/profile/work.nix` and import it from the host.
- [ ] Push the branch you will check out on the work Mac.

### On the machine

- [ ] `whoami` prints `franco.grobler`.
- [ ] `scutil --get LocalHostName` prints `CSLGPKPMH9Y4X`.
- [ ] Determinate Nix and Homebrew are installed.
- [ ] 1Password is in `/Applications` with the SSH agent and CLI integration on.
- [ ] The work signing key (the public key in `profile/work.nix`) is in the
  **Private** or **Homelab** vault, or that vault is added to
  `core/ssh/agent.toml`.
- [ ] The repo is cloned to `~/dotfiles`.
- [ ] [Bootstrap](bootstrap.md), then add this Mac's `nix.custom.conf` hash and
  run it again.
- [ ] [After the first switch](after-switch.md): `just ssh-keys`, switch the
  remote to SSH, `direnv allow`, `just claude-setup`.

## Apps already installed

Work Macs often come with Slack, Chrome or 1Password already in `/Applications`.
The casks install into `~/Applications` (`caskArgs.appdir`), so you can end up
with two copies. Remove the old copies from `/Applications` before the switch
(but not 1Password), or remove the duplicates afterwards.

1Password has to stay in `/Applications`. After the switch, check that
`/Applications/1Password.app` still exists. See [Before you
start](prerequisites.md#5-install-and-set-up-1password).
