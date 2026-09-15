# Who this machine is for -- see darwin/users.nix for the shape.
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
      isNormalUser = true;
      home = "/home/${name}";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
    }) cfg;

    programs.zsh.enable = true;

    home-manager.users = lib.mapAttrs (_: user: { imports = user.modules; }) cfg;
  };
}
