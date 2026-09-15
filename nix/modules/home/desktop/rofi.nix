# Application launcher. `rofi` in current nixpkgs is the wayland-capable build
# — the separate `rofi-wayland` package was merged back into it.
{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.ghostty}/bin/ghostty";
  };
}
