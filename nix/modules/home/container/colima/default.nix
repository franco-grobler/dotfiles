# Colima is the macOS container runtime: docker needs a VM there whether you
# like it or not, so it may as well be a declared one. Linux runs dockerd
# natively instead — see nixos/docker.nix — so this whole module is a no-op
# there, including the profile, which is aarch64 + vz + virtiofs throughout.
{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  # The colima binary itself comes from homebrew (darwin/homebrew.nix); these
  # are the client-side pieces nixpkgs provides.
  home.packages = with pkgs; [
    docker
    docker-buildx
    docker-credential-helpers
  ];

  xdg.configFile."colima/default/colima.yaml".source = ./colima.yaml;
}
