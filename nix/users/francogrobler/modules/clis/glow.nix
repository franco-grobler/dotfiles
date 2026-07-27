{ config, ... }:
{
  xdg.configFile."glow/glow.yml".source = ../../../../config/glow.yml;
}
