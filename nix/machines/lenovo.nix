{
  pkgs,
  currentSystemUser,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware/lenovo.nix
  ];
  boot = {
    loader = {
      grub = {
        # Bootloader.
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
    };
  };

  environment = {
    # Hint Electron apps to use Wayland
    sessionVariables.NIXOS_OZONE_WL = "1";

    systemPackages = [
      pkgs.kitty # required for the default Hyprland config
    ];
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager = {
      # Enable networking
      enable = true;
      wifi.backend = "iwd";
    };
    wireless = {
      iwd.enable = true;
      userControlled.enable = true;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];

      trusted-users = [
        "root"
        currentSystemUser
      ];
    };
  };

  programs.hyprland.enable = true; # enable Hyprland

  services = {
    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    # desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "za";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    pam.services.sudo.fprintAuth = true;
  };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.francogrobler = {
    isNormalUser = true;
    description = "Franco Grobler";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      thunderbird
    ];
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
