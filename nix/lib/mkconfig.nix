{ inputs }:

{
  system,
  user,
  channel,
}:

let
  inherit (inputs) home-manager;
  userHMConfig = ../users/${user}/home.nix;
in
home-manager.lib.homeManagerConfiguration {
  pkgs = channel.basePkgs;

  extraSpecialArgs = {
    inherit inputs;
    systemName = "x86_64-linux";
    isWSL = false;
  };

  modules = [
    { nixpkgs.overlays = channel.overlays; }
    { nixpkgs.config.allowUnfree = true; }

    {
      home.username = "${user}";
      home.homeDirectory = "/home/${user}";
    }

    userHMConfig
  ];
}
