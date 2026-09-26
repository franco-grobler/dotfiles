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

  # Skylake GT2 (HD 520). enable = true alone gets mesa/iris, so Hyprland
  # composites on the GPU, but it ships no VA-API driver -- browsers then decode
  # every video frame in software, which this 2-core CPU cannot keep up with.
  # iHD is the Gen9+ driver; the vdpau pair is for the handful of players that
  # only speak VDPAU.
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;

  # power-profiles-daemon boots into balanced and has no option for a default,
  # so pin performance once it is up. The Waybar module can still switch
  # profiles by hand afterwards; this only decides where each boot starts.
  systemd.services.power-profile-performance = {
    description = "Pin power-profiles-daemon to the performance profile";
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];
    requires = [ "power-profiles-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
    };
  };

  # Nerd Font glyphs (Waybar/Walker icons) plus emoji for the Walker
  # symbol picker must resolve system-wide (greetd, SDDM, lock screen).
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  environment.sessionVariables = {
    # Tell Electron/Chromium apps to use Wayland rather than XWayland.
    NIXOS_OZONE_WL = "1";
    # Skip libva's driver probe and go straight to iHD.
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    # For checking that the above actually took: `vainfo` lists the hardware
    # decode profiles, `glxinfo -B` the GL renderer.
    libva-utils
    mesa-demos
  ];
}
