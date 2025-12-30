{ pkgs }:
{
  programs.go = {
    enable = true;
    env = {
      GOPATH = "$HOME/.go";
    };
    telemetry = {
      mode = "on";
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.jre;
  };
}
