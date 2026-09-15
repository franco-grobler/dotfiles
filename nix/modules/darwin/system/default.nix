# macOS system configuration that has nothing to do with which user you are.
{ features, ... }:
{
  imports = with features; [
    nix-daemon
    locale
    macos-defaults
    touch-id
  ];
}
