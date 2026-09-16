# Nix supplies the binary; the *configuration* stays in the working copy,
# because lazy.nvim manages its own plugin lockfile and wants to write to it.
#
# `mkOutOfStoreSymlink` is what makes that declarative without making it
# read-only: ~/.config/nvim points straight at ~/dotfiles/nvim, so edits there
# are live and no activation is needed to try a change -- but the link itself
# is now created by `switch` rather than by remembering to run install.sh on a
# fresh machine.
{ config, pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];
  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/nvim";
}
