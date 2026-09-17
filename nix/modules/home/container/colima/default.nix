# Colima is the macOS container runtime: docker needs a VM there whether you
# like it or not, so it may as well be a declared one. Linux runs dockerd
# natively instead — see nixos/docker.nix — so this whole module is a no-op
# there, including the profile, which is aarch64 + vz + virtiofs throughout.
{ config, lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  # The colima binary itself comes from homebrew (darwin/homebrew.nix); these
  # are the client-side pieces nixpkgs provides.
  home.packages = with pkgs; [
    docker
    docker-buildx
    docker-credential-helpers
  ];

  # Colima rewrites this file on every `start` -- it persists the merged config
  # back to disk -- so a read-only store symlink makes the VM fail to come up.
  # `mkOutOfStoreSymlink` keeps it declarative but writable: colima's edits land
  # in the working copy, and `git diff` shows what it changed.
  xdg.configFile."colima/default/colima.yaml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.dotfiles.root}/nix/modules/home/container/colima/colima.yaml";
}
