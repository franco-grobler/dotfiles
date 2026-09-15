{ pkgs, ... }:
{
  home.packages = [ pkgs.posting ];
  xdg.configFile."posting/config.yaml".source = ./config.yaml;
}
