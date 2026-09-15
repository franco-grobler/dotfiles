# NetworkManager, so there is a way to join wifi once the desktop is up.
{
  networking.networkmanager.enable = true;
  users.users.francogrobler.extraGroups = [ "networkmanager" ];
}
