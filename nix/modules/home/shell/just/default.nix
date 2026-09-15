{ pkgs, ... }:
{
  home.packages = [ pkgs.just ];
  home.shellAliases.justg = "just --global-justfile";
  xdg.configFile."just/justfile".source = ./justfile;
}
