{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  programs.gpg.enable = !isDarwin;

  services.gpg-agent = {
    enable = isLinux;
    pinentry.package = pkgs.pinentry-tty;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
}
