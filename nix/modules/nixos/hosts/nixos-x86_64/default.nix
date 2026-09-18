# Personal linux desktop (x86_64).
{
  features,
  home,
  mkPkgs,
  ...
}:
{
  imports = with features; [
    base
    docker
    desktop
    ./hardware-configuration.nix
  ];

  nixpkgs.pkgs = mkPkgs {
    system = "x86_64-linux";
    channel = "stable";
  };

  networking.hostName = "nixos-x86_64";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  dotfiles.users.francogrobler = {
    description = "Franco Grobler";

    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ9idmuyl8gR255rm13mXTRG/tt2aINtYuSEQG40TKF"
    ];
    modules = with home; [
      base
      dev
      terminal
      monitor
      desktop
      personal
      # A single program can be added here too -- e.g. `lazysql` -- without
      # going through a group.
    ];
  };
}
