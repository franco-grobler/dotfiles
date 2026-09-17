# Linux graphical session: Hyprland and everything that hangs off it. Never
# imported on darwin. Walker is the Omarchy-style launcher; rofi stays
# available as an aggregate but is not part of the session.
{ features, ... }:
{
  imports = with features; [
    hyprland
    waybar
    walker
    mako
    hyprlock
    hypridle
    hyprpaper
    omarchy
    theme
    pointer
    xresources
    gui-apps
  ];
}
