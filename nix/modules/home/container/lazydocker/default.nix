{ pkgs, ... }:
{
  home.packages = [ pkgs.lazydocker ];
  xdg.configFile."lazydocker/config.yml".source = ./config.yml;
}
