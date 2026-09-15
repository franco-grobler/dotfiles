{ pkgs, ... }:
{
  home.packages = [ pkgs.gh ];
  xdg.configFile = {
    "gh/config.yml".source = ./config.yml;
    "gh/hosts.yml".source = ./hosts.yml;
  };
}
