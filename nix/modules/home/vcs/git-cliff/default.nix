{ pkgs, ... }:
{
  home.packages = [ pkgs.git-cliff ];
  xdg.configFile."git-cliff/cliff.toml".source = ./cliff.toml;
}
