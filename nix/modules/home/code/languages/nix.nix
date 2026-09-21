# Nix. nixd is installed in core/nix-tools.nix for its completion on
# nixos/darwin/home-manager options; nil is the server LazyVim's nix extra
# actually enables, so both end up attached to these buffers.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixfmt
    statix
  ];
}
