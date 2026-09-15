# `programs.lazygit` force-disables its config file whenever `settings` is
# empty, which fights an `xdg.configFile` entry for the same path. The config
# here is verbatim YAML (comments and all), so install the package directly and
# own the file outright.
{ pkgs, ... }:
{
  home.packages = [ pkgs.lazygit ];
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
