{ pkgs, ... }:
{
  home.packages = [ pkgs.opencode ];
  xdg.configFile."opencode/opencode.jsonc".source = ./opencode.jsonc;
}
