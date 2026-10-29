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

  networking.hostName = "nixos-x8664";

  # Legacy BIOS/MBR: the disk is a single ext4 partition with no EFI system
  # partition, so systemd-boot (UEFI-only) cannot be used here. GRUB installs
  # its boot code into the MBR gap ahead of sda1.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
  };

  dotfiles.users.francogrobler = {
    description = "Franco Grobler";

    authorizedKeys = [
      # NixOs Laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ9idmuyl8gR255rm13mXTRG/tt2aINtYuSEQG40TKF"
      # Bamboo Admin -- what every homelab alias authenticates with.
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF87NlIs1zcgwRJC2pD9J+QCkZKFQFUFo3qVEV2qgxjT"
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
