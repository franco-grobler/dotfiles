{
  pkgs,
  lib,
  isWSL,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
