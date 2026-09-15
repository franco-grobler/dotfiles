# The neovim *configuration* is still stowed from ~/dotfiles/nvim (lazy.nvim
# manages its own plugin lockfile); nix only supplies the binary.
{ pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];
  home.sessionVariables.EDITOR = "nvim";
}
