# Determinate Nix owns /etc/nix/nix.conf — the file says so itself — so
# nix-darwin must not manage the daemon.
#
# The catch is that `nix.enable = false` also makes `nix.settings` and
# `nix.extraOptions` silently inert: nix-darwin then writes no nix.conf at all,
# so anything set there is config that looks authoritative and does nothing.
# Determinate's nix.conf ends with `!include nix.custom.conf`, which is the
# supported place for local settings, and nix-darwin can own that file.
{
  config,
  lib,
  ...
}:
let
  trustedUsers = lib.concatStringsSep " " (
    [ "root" ] ++ lib.attrNames config.dotfiles.users
  );
in
{
  nix.enable = false;

  environment.etc."nix/nix.custom.conf" = {
    # The Determinate installer wrote this file at install time, and nix-darwin
    # refuses to replace an /etc file whose contents it does not recognise.
    #
    # If activation aborts on another mac with "Unexpected files in /etc", add
    # that machine's `shasum -a 256 /etc/nix/nix.custom.conf` to this list. The
    # displaced file is kept as nix.custom.conf.before-nix-darwin.
    knownSha256Hashes = [
      # Francos-MacBook-Air
      "afae59aee64e05709962ccbeef2efd48c6cbc80f4e65fce03f0a05c303914959"
    ];

    text = ''
      trusted-users = ${trustedUsers}

      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=

      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.stateVersion = 6;
}
