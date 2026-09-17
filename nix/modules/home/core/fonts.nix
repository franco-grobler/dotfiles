{ pkgs, ... }:
{
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts-emoji
  ];
  fonts.fontconfig.enable = pkgs.stdenv.isLinux;
}
