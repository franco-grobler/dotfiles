# Lua -- also the language this whole Neovim config is written in.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lua-language-server # fast-moving: 3.18.1 vs 3.19.1
    stylua
  ];
}
