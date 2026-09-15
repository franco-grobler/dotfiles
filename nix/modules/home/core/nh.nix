# `nh os switch` / `nh home switch` without having to remember which output
# class this host lives under.
{ pkgs, hostName, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  outputClass =
    if isDarwin then
      "darwinConfigurations"
    else if isLinux then
      "nixosConfigurations"
    else
      "homeConfigurations";
in
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 2";
    };
    flake = "$HOME/dotfiles/nix#${outputClass}.${hostName}";
  };
}
