# Linux graphical session: Hyprland and everything that hangs off it. Never
# imported on darwin.
{ features, ... }:
{
  imports = with features; [
    hyprland
    waybar
    mako
    rofi
    hyprlock
    pointer
    xresources
    gui-apps
  ];
}
