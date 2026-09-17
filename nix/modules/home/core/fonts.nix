{ pkgs, ... }:
{
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts-color-emoji
  ];
  fonts.fontconfig.enable = pkgs.stdenv.isLinux;
}
