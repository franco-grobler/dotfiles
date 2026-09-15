{ pkgs, ... }:
{
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 24;
    gtk.enable = true;
    # Still wanted: XWayland apps read the X cursor settings.
    x11.enable = true;
  };
}
