# Unlike claude and opencode next door, there is no Homebrew cask for this
# one, so the nixpkgs build is used on every platform.
{ pkgs, ... }:
{
  home.packages = [ pkgs.cursor-cli ];
}
