# LaTeX. Previewing is pointed at Skim in nvim/lua/config/options.lua.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    texlab
    tex-fmt
  ];
}
