# Turns every `hosts/<name>` aggregate into a real system configuration. Adding
# a host is one file under modules/{darwin,nixos}/hosts/ — nothing here changes.
#
# `features` is the host's own class; `home` is the home-manager class. Both are
# passed as specialArgs so a module can write `with features; [ ... ]` and never
# reach for flake-level `config`.
{
  config,
  inputs,
  lib,
  mkPkgs,
  ...
}:
let
  build =
    class: builder:
    let
      aggregates = config.flake.modules.${class};
    in
    lib.mapAttrs' (
      name: module:
      let
        hostName = lib.removePrefix "hosts/" name;
      in
      lib.nameValuePair hostName (builder {
        specialArgs = {
          inherit inputs hostName mkPkgs;
          features = aggregates;
          home = config.flake.modules.homeManager;
        };
        modules = [ module ];
      })
    ) (lib.filterAttrs (n: _: lib.hasPrefix "hosts/" n) aggregates);
in
{
  flake.darwinConfigurations = build "darwin" inputs.nix-darwin.lib.darwinSystem;
  flake.nixosConfigurations = build "nixos" inputs.nixpkgs.lib.nixosSystem;
}
