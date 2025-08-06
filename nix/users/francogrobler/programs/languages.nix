{ pkgs }:
{
  programs.go = {
    enable = true;
    goPath = "$HOME/.go";
    telemetry = {
      mode = "on";
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.jre;
  };
}
