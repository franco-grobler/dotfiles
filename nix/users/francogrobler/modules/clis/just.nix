{ config, ... }:
{
  xdg.configFile."just/justfile".source = ../../../../config/justfile;
}
