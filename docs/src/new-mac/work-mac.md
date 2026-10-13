# The work MacBook

The work Mac follows the same steps as any other Mac. This page covers only what
is different.

## What it gets

`nix/modules/darwin/hosts/work-mbp.nix`:

- **Account**: `franco.grobler`. The personal hosts use `francogrobler`.
- **Home modules**: `base`, `dev`, `terminal`, `work`. It leaves out `monitor`
  and the personal identity.
- **System modules**: only `base`, so homebrew installs just the baseline from
  `darwin/homebrew.nix`. There is no `darwin/profile/work.nix` yet.

`nix/modules/home/profile/work.nix` adds:

- the Cloudsmiths commit email and its own SSH signing key, which is also the
  github.com auth key;
- `awscli2`, `google-cloud-sdk`, `kubectl` and `kubernetes-helm`;
- an empty `dotfiles.sessions`, for work tmuxinator layouts still to be added.

## Checklist

### In the repo

- [ ] Rename `work-mbp.nix` to the Mac's `LocalHostName` (there is a `TODO` in
  the file), and update `nix/README.md` to match. Until then, prefix
  commands with `NIXNAME=work-mbp`.
- [ ] Push the branch you will check out on the work Mac.
- [ ] Optional: add `nix/modules/darwin/profile/work.nix` for work-only casks,
  and import it from the host, the same way `personal` is imported on
  `Francos-MacBook-Air`.

### On the machine

- [ ] `whoami` prints `franco.grobler`.
- [ ] Determinate Nix and Homebrew are installed, and you are signed in to the
  App Store.
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
