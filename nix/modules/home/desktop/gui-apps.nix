# Graphical applications for the linux desktop. macOS GUI apps come from
# homebrew casks instead — see darwin/homebrew.nix.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _1password-gui
    alacritty
    chromium
    firefox
    freecad-wayland
    ghostty
    valgrind
    vial
    zathura
  ];
}
