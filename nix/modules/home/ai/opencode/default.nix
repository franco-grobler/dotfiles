{ config, ... }:
{
  # home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/nix/modules/home/ai/opencode/opencode.jsonc";
}
