{ config, pkgs, ... }:
{
  home.sessionVariables.BAT_CONFIG_PATH = "${config.xdg.configHome}/bat/config";

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
    ];
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
    };
  };
}
