# NetworkManager, so there is a way to join wifi once the desktop is up.
{ config, lib, ... }:
{
  networking.networkmanager.enable = true;
  users.users = lib.genAttrs (lib.attrNames config.dotfiles.users) (_: {
    extraGroups = [ "networkmanager" ];
  });
}
