# Status bar. Started by Hyprland's exec-once rather than a systemd user unit,
# so it comes up with the session and dies with it.
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 8;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/submap"
      ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "clock"
        "tray"
      ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
      };

      "hyprland/window" = {
        max-length = 80;
        separate-outputs = true;
      };

      clock = {
        format = "{:%Y-%m-%d %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      cpu.format = "cpu {usage}%";
      memory.format = "mem {percentage}%";

      battery = {
        format = "bat {capacity}%";
        format-charging = "chg {capacity}%";
        states = {
          warning = 30;
          critical = 15;
        };
      };

      network = {
        format-wifi = "{essid} {signalStrength}%";
        format-ethernet = "eth";
        format-disconnected = "offline";
      };

      pulseaudio = {
        format = "vol {volume}%";
        format-muted = "muted";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
    };

    style = builtins.readFile ./style.css;
  };
}
