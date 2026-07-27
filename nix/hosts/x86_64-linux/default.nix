{ _, ... }:
{
  imports = [ ../../users/francogrobler/os/nixos.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  networking.hostName = "nixos-x86_64";
}
