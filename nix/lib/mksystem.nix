{ inputs }:

name:
{
  system,
  user,
  channel,
  darwin ? false,
}:

let
  isWSL = false;

  machineConfig = ../hosts/${name}/default.nix;
  userHMConfig = ../users/${user}/home.nix;

  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;

  hmModule = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = channel.overlays; }
    { nixpkgs.config.allowUnfree = true; }

    machineConfig

    hmModule.home-manager
    {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs isWSL;
          systemName = name;
        };
        users.${user} = {
          imports = [ userHMConfig ];
        };
      };
    }

    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        inherit isWSL inputs;
      };
    }
  ];
}
