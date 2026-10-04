# NetworkManager, so there is a way to join wifi once the desktop is up.
#
# WireGuard tunnels are NetworkManager connections rather than declared here:
# `nmcli connection import type wireguard file wg0.conf` brings one in, keys
# and all, without the private key ever touching the store.
{ config, lib, ... }:
{
  networking.networkmanager.enable = true;

  # A full-tunnel WireGuard connection routes replies back through wg0, which
  # the strict reverse-path filter drops as spoofed.
  networking.firewall.checkReversePath = "loose";

  users.users = lib.genAttrs (lib.attrNames config.dotfiles.users) (_: {
    extraGroups = [ "networkmanager" ];
  });
}
