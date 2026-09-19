{ config, lib, pkgs, ... }:
{
  # macOS gets opencode from Homebrew (anomalyco/tap/opencode); install the
  # nix build (tracked on unstable via channels.nix) everywhere else.
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/nix/modules/home/ai/opencode/opencode.jsonc";
}
