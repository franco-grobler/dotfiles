# Makes `nix flake check` mean something.
#
# `darwinConfigurations` and `nixosConfigurations` are not outputs that
# `nix flake check` builds, so without this the command is very nearly a no-op
# and CI has to enumerate the hosts by hand. Re-exposing each host's toplevel
# as a check puts every machine behind the one command, locally and in CI.
#
# Hosts are filtered to the system currently being evaluated, so a linux runner
# checks the linux hosts and a mac checks the macs; `nix flake check --all-systems`
# still only *evaluates* the rest, which is the useful half on the wrong kernel.
{ config, lib, ... }:
{
  perSystem =
    { system, ... }:
    let
      forSystem = lib.filterAttrs (
        _: host: host.pkgs.stdenv.hostPlatform.system == system
      );

      checksFor =
        prefix: toplevel: hosts:
        lib.mapAttrs' (
          name: host: lib.nameValuePair "${prefix}-${name}" (toplevel host)
        ) (forSystem hosts);
    in
    {
      checks =
        checksFor "darwin" (host: host.system) config.flake.darwinConfigurations
        // checksFor "nixos" (
          host: host.config.system.build.toplevel
        ) config.flake.nixosConfigurations
        // checksFor "home" (
          host: host.activationPackage
        ) config.flake.homeConfigurations;
    };
}
