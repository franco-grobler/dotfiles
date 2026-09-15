{ config, pkgs, ... }:
{
  home.packages = [ pkgs.git-cliff ];
  home.sessionVariables.GIT_CLIFF_CONFIG = "${config.xdg.configHome}/git-cliff/cliff.toml";
  xdg.configFile."git-cliff/cliff.toml".source = ./cliff.toml;
}
