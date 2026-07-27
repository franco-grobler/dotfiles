{ config, ... }:
{
  programs.go = {
    enable = true;
    env = {
      GOPATH = "${config.xdg.configHome}/.go";
    };
  };
}
