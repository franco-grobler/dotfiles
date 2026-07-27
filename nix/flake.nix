{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      ...
    }@inputs:
    let
      mkChannel = import ./lib/channels.nix { inherit inputs; };
      mkSystem = import ./lib/mksystem.nix { inherit inputs; };
      mkConfig = import ./lib/mkconfig.nix { inherit inputs; };

      userName = "francogrobler";
    in
    {
      darwinConfigurations.apple-silicone = mkSystem "apple-silicone" {
        system = "aarch64-darwin";
        user = userName;
        darwin = true;
        channel = mkChannel {
          system = "aarch64-darwin";
          channelBase = "unstable";
        };
      };

      homeConfigurations.x86_64-linux = mkConfig {
        system = "x86_64-linux";
        user = userName;
        channel = mkChannel {
          system = "x86_64-linux";
          channelBase = "stable";
        };
      };

      nixosConfigurations.x86_64-linux = mkSystem "x86_64-linux" {
        system = "x86_64-linux";
        user = userName;
        channel = mkChannel {
          system = "x86_64-linux";
          channelBase = "stable";
        };
      };
    };
}
