{ pkgs, enable }:
{
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./envs.nix
    ./input.nix
    ./looknfeel.nix
    ./windows.nix

    ./plugins/default.nix
  ];

  programs.chromium = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    inherit enable;

    settings = {
      # Default applications
      "$browser" = "chromium --new-window --ozone-platform=wayland";
      "$fileManager" = "nautilus --new-window";
      "$messenger" = "signal-desktop";
      "$passwordManager" = "1password";
      "$terminal" = "ghostty";
      "$webapp" = "$browser --app";
    };

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
  };

  services.hyprpolkitagent.enable = true;
}
