{ pkgs, ... }:
{
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
