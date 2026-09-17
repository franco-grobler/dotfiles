# Notification daemon, Tokyo Night. Started from Hyprland's exec-once so it
# lives and dies with the session.
#
# Palette: bg #1a1b26, fg #c0caf5, border #3b4261, progress/blue #7aa2f7.
{
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 10";
      background-color = "#1a1b26";
      text-color = "#c0caf5";
      border-color = "#3b4261";
      progress-color = "#7aa2f7";
      width = 420;
      height = 110;
      padding = "10";
      margin = "10";
      border-size = 2;
      border-radius = 8;
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      sort = "-time";
      group-by = "app-name";
      anchor = "top-right";
      layer = "overlay";
      actions = true;
      format = "<b>%s</b>\\n%b";
      markup = true;
    };
  };
}
