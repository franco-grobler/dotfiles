{ config, pkgs }:
{
  programs = {
    go = {
      enable = true;
      telemetry = {
        mode = "on";
      };
      env = {
        GOPATH = [
          "${config.home.homeDirectory}/.go"
        ];
      };
    };

    java = {
      enable = true;
      package = pkgs.jre;
    };
  };
}
