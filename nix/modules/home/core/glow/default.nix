{ pkgs, ... }:
{
  home.packages = [ pkgs.glow ];
  xdg.configFile."glow/glow.yml".source = ./glow.yml;
}
