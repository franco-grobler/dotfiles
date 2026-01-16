{
  description = "Nix configuration";

  inputs = {
    # Default to stable, use unstable for some packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
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
      ghostty,
      ...
    }@inputs:
    let
      unstablePkgsFor =
        system:
        import inputs.nixpkgs-unstable {
          config.allowUnfree = true;
          inherit system;
        };
      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        (final: prev: rec {
          unstable = unstablePkgsFor prev.system;
          # Latest version of these
          inherit (unstable)
            bun
            devbox
            devenv
            gemini-cli
            gh
            github-copilot-cli
            nushell
            opencode
            ruff
            ty
            uv
            ;
        })
      ];

      mkSystem = import ./lib/mksystem.nix {
        inherit overlays nixpkgs inputs;
      };
      mkConfig = import ./lib/mkconfig.nix {
        inherit overlays nixpkgs inputs;
      };

      userName = "francogrobler";
    in
    {
      darwinConfigurations.apple-silicone = mkSystem "apple-silicone" {
        system = "aarch64-darwin";
        user = userName;
        darwin = true;
      };

      homeConfigurations.x86_64-linux = mkConfig {
        system = "x86_64-linux";
        user = userName;
      };

      nixosConfigurations.x86_64-linux = mkSystem "x86_64-linux" {
        system = "x86_64-linux";
        user = userName;
      };

      nixosConfigurations.wsl = mkSystem "wsl" {
        system = "x86_64-linux";
        user = userName;
        wsl = true;
      };
    };
}
