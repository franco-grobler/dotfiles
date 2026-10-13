# Troubleshooting

## `flake does not provide attribute darwinConfigurations.<name>`

The hostname has no matching host file. Run `just nix-target` to see what this
machine resolves to, then rename the host file or prefix the command with
`NIXNAME=<host>`.

## `Unexpected files in /etc`

This is normal on a new Mac. See
[Bootstrap](bootstrap.md#expect-the-first-switch-to-stop-on-etcnixnixcustomconf).

## `Too many authentication failures` over SSH

The agent is offering every key. Run `just ssh-keys` so each host gets its own
`IdentityFile`, and check that the host has an entry in `dotfiles.ssh.keys`.

## Commit signing fails with `No such file or directory`

`op-ssh-sign` was not found at `/Applications/1Password.app/…`. Move 1Password
to `/Applications`.

## GitHub rate limit while fetching inputs

```bash
just nix-token
```

## Determinate Nix is out of date

`just nix-switch` (or `just nix-upgrade-check`) tells you when an update is
available, but never installs it for you, because upgrading restarts the daemon:

```bash
sudo determinate-nixd upgrade
```

See [Updating Determinate Nix](../determinate-nix.md).
