{ config, ... }:
{
  xdg.configFile."git-cliff/cliff.toml".source = ../../../../config/cliff.toml;
}
