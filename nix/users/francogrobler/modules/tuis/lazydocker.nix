{ config, ... }:
{
  xdg.configFile."lazydocker/config.yml".source =
    ../../../../../lazydocker/config.yml;
}
