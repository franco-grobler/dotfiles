# Hyprland at the system level: the compositor binary, the session file greetd
# offers at login, portals, polkit, bluetooth/power services the Waybar
# modules expect, and fonts for the bar/launcher icons. The *configuration*
# lives in home/desktop/hyprland.nix.
{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # programs.hyprland already registers both the hyprland and GTK portals, which
  # is what gives Firefox and friends a working file picker and screen share.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;
  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;

  # Nerd Font glyphs (Waybar/Walker icons) plus emoji for the Walker
  # symbol picker must resolve system-wide (greetd, SDDM, lock screen).
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Tell Electron/Chromium apps to use Wayland rather than XWayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = [ pkgs.hyprpolkitagent ];
}
