# Hands the home-manager aggregates to the user's home configuration. `home` is
# the home-manager aggregate set; it becomes `features` inside those modules, so
# a home module and a darwin module read identically.
{
  inputs,
  hostName,
  home,
  ...
}:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs hostName;
      features = home;
    };
  };
}
