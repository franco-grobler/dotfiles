# PLACEHOLDER — replace with the real thing.
#
# Run `nixos-generate-config --show-hardware-config` on the machine and commit
# its output over this file. Only that knows the box's actual disk UUIDs, the
# kernel modules its storage controller needs, and which CPU vendor it is.
#
# Until then this is a generic UEFI x86_64 profile that will boot a machine
# whose partitions are labelled:
#
#   root : nixos   (ext4)
#   ESP  : BOOT    (vfat)
#
# `lsblk -o NAME,LABEL,FSTYPE` to check, `e2label` / `fatlabel` to set them.
{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {

    # Broad enough to find the root device on SATA, NVMe, USB or a VM disk.
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "sr_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
      "virtio_blk"
      "virtio_pci"
      "virtio_scsi"
    ];
    initrd.kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  hardware = {
    # Wifi and GPU firmware; without this a laptop typically has no network.
    enableRedistributableFirmware = true;

    # Harmless to enable both — each only applies on its own vendor's silicon.
    cpu.intel.updateMicrocode = lib.mkDefault true;
    cpu.amd.updateMicrocode = lib.mkDefault true;
  };

  networking.useDHCP = lib.mkDefault true;
}
