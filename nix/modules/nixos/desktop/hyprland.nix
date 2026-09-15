# Hyprland at the system level: the compositor binary, the session file greetd
# offers at login, portals, and the GPU bits. The *configuration* lives in
# home/desktop/hyprland.nix.
{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # programs.hyprland already registers both the hyprland and GTK portals, which
  # is what gives Firefox and friends a working file picker and screen share.
  xdg.portal.enable = true;

  security.polkit.enable = true;
  hardware.graphics.enable = true;

  # Tell Electron/Chromium apps to use Wayland rather than XWayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = [ pkgs.hyprpolkitagent ];
}
