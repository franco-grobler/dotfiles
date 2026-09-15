# gpg is linux-only here: on macOS, commit signing goes through the 1Password
# ssh agent (see git.nix) and there is no gpg key to hold.
{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  programs.gpg.enable = isLinux;

  services.gpg-agent = {
    enable = isLinux;
    pinentry.package = pkgs.pinentry-tty;

    # A year, i.e. unlock once per boot and never think about it again. The
    # key this guards is not the one protecting anything remote -- that is the
    # 1Password agent, which has its own lock.
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
}
