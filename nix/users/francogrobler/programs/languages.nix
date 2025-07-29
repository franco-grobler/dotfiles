{ pkgs }:
{
  programs.java = {
    enable = true;
    packages = pkgs.jdk22;
  };
}
