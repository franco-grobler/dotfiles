# The floor: XDG layout, locale, fonts, and the tools you would miss
# immediately on a bare machine.
{ features, ... }:
{
  imports = with features; [
    state-version
    repo
    xdg
    locale
    fonts
    unix-tools
    nix-tools
    bat
    glow
    nh
    gpg
    ssh
  ];
}
