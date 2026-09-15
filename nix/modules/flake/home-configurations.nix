# Stand-alone home-manager outputs, derived from the hosts rather than restated.
#
# Every account a host declares in `dotfiles.users` gets a matching
# `homeConfigurations."<user>@<host>"`, built from that user's own module list
# and that host's pkgs. Nothing here needs touching when a host gains a user or
# changes what it imports.
{
  config,
  inputs,
  lib,
  ...
}:
let
  hosts = config.flake.darwinConfigurations // config.flake.nixosConfigurations;

  homesFor =
    hostName: host:
    lib.mapAttrsToList (
      user: settings:
      lib.nameValuePair "${user}@${hostName}" (
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit (host) pkgs;
          extraSpecialArgs = {
            inherit inputs hostName;
            features = config.flake.modules.homeManager;
          };
          modules = settings.modules ++ [
            {
              home.username = user;
              home.homeDirectory = host.config.users.users.${user}.home;
            }
          ];
        }
      )
    ) host.config.dotfiles.users;
in
{
  flake.homeConfigurations = lib.listToAttrs (
    lib.concatLists (lib.mapAttrsToList homesFor hosts)
  );
}
