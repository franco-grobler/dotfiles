# Graphical applications for the linux desktop (Omarchy defaults first).
# macOS GUI apps come from homebrew casks instead — see darwin/homebrew.nix.
# Browsers (Chrome, Firefox, Zen) live in browsers.nix.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _1password-gui
    alacritty
    blueman
    freecad-wayland
    ghostty
    nautilus
    pavucontrol
    valgrind
    vial
    zathura
  ];
}
