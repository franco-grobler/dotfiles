# Notification daemon, started from Hyprland's exec-once.
{
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 10";
      background-color = "#1d1f21";
      text-color = "#c5c8c6";
      border-color = "#b294bb";
      border-size = 2;
      border-radius = 6;
      default-timeout = 6000;
      anchor = "top-right";
    };
  };
}
