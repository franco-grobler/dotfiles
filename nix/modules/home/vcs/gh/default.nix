{ pkgs, config, ... }:
{
  home.packages = [ pkgs.gh ];
  xdg.configFile = {
    "gh/config.yml".source = ./config.yml;
    "gh/hosts.yml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/nix/modules/home/vcs/gh/hosts.yml";
  };
}
