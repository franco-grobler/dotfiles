# Who this machine is for. A host declares its people:
#
#   dotfiles.users.francogrobler = {
#     description = "Franco Grobler";
#     modules = with home; [ base dev terminal personal ];
#   };
#
# and the account, the home-manager hand-off and every other reference to the
# name follow from that.
{
  config,
  features,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.users;
in
{
  imports = [ features.home-manager ];

  options.dotfiles.users = lib.mkOption {
    default = { };
    description = ''
      Human accounts on this host, and the home-manager aggregates each one
      gets. Everything that needs a username -- trusted-users, group
      membership, the home-manager hand-off -- reads it from here.
    '';
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            description = lib.mkOption {
              type = lib.types.str;
              default = name;
              description = "Full name for the account.";
            };
            modules = lib.mkOption {
              type = lib.types.listOf lib.types.deferredModule;
              default = [ ];
              description = "home-manager aggregates this user gets.";
            };
          };
        }
      )
    );
  };

  config = {
    users.users = lib.mapAttrs (name: user: {
      inherit (user) description;
      home = "/Users/${name}";
      shell = pkgs.zsh;
    }) cfg;

    # macOS applies system-wide defaults on behalf of exactly one account.
    system.primaryUser = lib.mkIf (cfg != { }) (lib.head (lib.attrNames cfg));

    home-manager.users = lib.mapAttrs (_: user: { imports = user.modules; }) cfg;
  };
}
