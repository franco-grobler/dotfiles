# Working *on* nix, on every machine.
#
# The thing this buys you day to day is `,`: run a program that is not
# installed, without editing the config for it.
#
#   , ripgrep-all           run it once, from the store, install nothing
#   nix-locate bin/ffmpeg   which package would give me this binary
#
# The index those two read is normally an hour of local `nix-index`; the
# nix-index-database input ships a prebuilt one and refreshes it with the
# lockfile instead.
{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  programs.nix-index-database.comma.enable = true;

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    # Language server for nix, with completion on nixos / nix-darwin /
    # home-manager options -- the tree is ~100 modules and every option name in
    # it was previously typed blind.
    nixd

    # Readable build output. `nh` picks this up automatically when it is on
    # PATH, so every switch from here on is a progress table rather than a wall
    # of log.
    nix-output-monitor

    # Answering "why is this in my closure" and "what did that switch actually
    # change" -- `nix-tree ~/.nix-profile`, `nvd diff /run/current-system result`.
    nix-tree
    nvd
  ];
}
