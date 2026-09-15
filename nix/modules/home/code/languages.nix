# Language runtimes and the formatters/linters that go with them.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cursor-cli
    nodejs
    python314
    rustup
    nixfmt
    statix
  ];
}
