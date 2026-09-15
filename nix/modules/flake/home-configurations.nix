# Stand-alone home-manager outputs, for machines where nix does not own the OS
# (a work box you do not admin, a remote shell account, WSL). They compose from
# exactly the same aggregates the system configurations use.
{
  config,
  inputs,
  mkPkgs,
  ...
}:
let
  home = config.flake.modules.homeManager;

  mkHome =
    {
      system,
      channel ? "stable",
      hostName,
      homeDirectory,
      modules ? [ ],
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs { inherit system channel; };
      extraSpecialArgs = {
        inherit inputs hostName;
        features = home;
      };
      modules = [
        home.francogrobler
        { home.homeDirectory = homeDirectory; }
      ]
      ++ modules;
    };
in
{
  flake.homeConfigurations = {
    "francogrobler@nixos-x86_64" = mkHome {
      system = "x86_64-linux";
      hostName = "nixos-x86_64";
      homeDirectory = "/home/francogrobler";
      modules = with home; [
        base
        dev
        terminal
        desktop
        personal
      ];
    };

    "francogrobler@work-mbp" = mkHome {
      system = "aarch64-darwin";
      hostName = "work-mbp";
      homeDirectory = "/Users/francogrobler";
      modules = with home; [
        base
        dev
        terminal
        work
      ];
    };
  };
}
