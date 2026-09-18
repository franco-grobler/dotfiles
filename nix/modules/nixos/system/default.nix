{ features, ... }:
{
  imports = with features; [
    nix-daemon
    locale
    networking
    ssh
  ];
}
