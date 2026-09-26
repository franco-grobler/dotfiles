# Google Chrome (proprietary) for the linux desktop.
#
# home-manager cannot force-install extensions into proprietary Chrome
# (nix-community/home-manager#1383), so the extension force-list lives in the
# NixOS policy module nixos/desktop/chrome.nix, which writes
# /etc/opt/chrome/policies/managed. This module only installs Chrome itself,
# Wayland-native.
{
  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--gtk-version=4"
      # Chrome will not use VA-API unless asked, even with a driver present.
      # The GL variant is the one that works on Wayland/iris; the plain
      # VaapiVideoDecoder flag covers the older code path.
      "--enable-features=AcceleratedVideoDecodeLinuxGL,VaapiVideoDecoder"
    ];
  };
}
