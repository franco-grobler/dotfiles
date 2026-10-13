# Updating Determinate Nix

The Macs run [Determinate
Nix](https://docs.determinate.systems/determinate-nix/). It is installed outside
the flake, so **`just nix-update` and `just nix-switch` never update Nix
itself**. You upgrade it by hand.

This only applies to the Macs. The NixOS host uses the Nix that ships with
nixpkgs, which moves with `flake.lock` like any other package.

## Why the flake doesn't manage it

`nix/modules/darwin/system/nix-daemon.nix` sets `nix.enable = false`.
Determinate owns the daemon and `/etc/nix/nix.conf`, and nix-darwin only writes
`/etc/nix/nix.custom.conf`, which Determinate's `nix.conf` includes. Your
settings (`trusted-users`, substituters, `keep-outputs`) live in that file, so
they don't depend on the Nix version.

## Check whether you're behind

```bash
just nix-upgrade-check
```

It prints one of these:

```text
Determinate Nix 3.23.1 is up to date
Determinate Nix 3.23.1 is available (running 3.23.0).
```

`just nix-switch` runs the same check after every switch, and only prints
anything when you're behind. The script behind it,
`_scripts/nix_upgrade_check.sh`, exits `1` when you're behind and `0` otherwise,
including on machines without Determinate Nix, so other scripts can use it as a
gate.

For the full picture, ask `determinate-nixd` directly:

```bash
determinate-nixd version
```

It prints the daemon and client versions, the latest version, and upgrade
instructions if you're behind. See [Check your
version](https://docs.determinate.systems/determinate-nix/determinate-nixd/#version).

## Upgrade

```bash
sudo determinate-nixd upgrade
```

This installs the latest version Determinate Systems recommends. It needs
`sudo`. The upgrade restarts the Nix daemon, so don't run it while a build or a
`just nix-switch` is in progress.

To install a specific version instead, for example to roll back:

```bash
sudo determinate-nixd upgrade --version v3.23.0
```

See [Upgrade
Nix](https://docs.determinate.systems/determinate-nix/determinate-nixd/#upgrade)
for the details.

You can also re-run the Determinate macOS package from the [Determinate
docs](https://docs.determinate.systems/). It upgrades the install in place and
keeps your store and profiles.

## Afterwards

```bash
just nix-upgrade-check # should say "up to date"
nix --version
just nix-build # make sure this host still builds
```

## If something goes wrong

- **`nix` is missing after a macOS update.** This happens to installs from the
  upstream nixos.org installer, which doesn't survive macOS upgrades. Re-run the
  Determinate package, which upgrades in place and keeps the store and profiles.
  See [Nix disappeared from my
  Mac](https://docs.determinate.systems/troubleshooting/nix-disappeared-from-macos/).
- **Moving between upstream Nix and Determinate Nix.** See [Migrating from
  upstream
  Nix](https://docs.determinate.systems/guides/migrating-from-upstream-nix/).
- **Daemon settings and other `determinate-nixd` commands.** See the
  [Determinate Nixd
  reference](https://docs.determinate.systems/determinate-nix/determinate-nixd/).
