{
  nixpkgs,
  overlays,
  inputs,
}:

{ system, user }:
let
  inherit (inputs) home-manager;
in
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    # Allow unfree packages.
    { nixpkgs.config.allowUnfree = true; }

    {
      home.username = "${user}";
      home.homeDirectory = "/home/${user}";
    }

    (import ../users/${user}/home-manager.nix {
      inherit inputs;
      pkgs = nixpkgs.legacyPackages.${system};
      isWSL = false;
    })
  ];
}
