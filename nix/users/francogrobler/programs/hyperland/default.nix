{ enable }:
{
  wayland.windowManager.hyprland = {
    inherit enable;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
  };
}
