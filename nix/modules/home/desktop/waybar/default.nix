# Status bar, Omarchy-style. Started by Hyprland's exec-once rather than a
# systemd user unit, so it comes up with the session and dies with it.
#
# Layout mirrors Omarchy 3.x: workspaces left, clock center, system tray and
# indicators right. Tokyo Night hex is duplicated in style.css -- keep the two
# in sync when retheming.
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 0;

      modules-left = [
        "custom/omarchy"
        "hyprland/workspaces"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "tray"
        "bluetooth"
        "network"
        "wireplumber"
        "cpu"
        "power-profiles-daemon"
        "battery"
      ];

      "custom/omarchy" = {
        format = "󰣇";
        tooltip = "Omarchy menu (Super+Alt+Space)";
        on-click = "omarchy-menu";
      };

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "0";
          active = "󱓻";
        };
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };

      clock = {
        format = "{:%A %I:%M %p}";
        format-alt = "{:%d %B W%V %Y}";
        tooltip = false;
      };

      cpu = {
        interval = 5;
        format = "󰍛";
        on-click = "ghostty -e btop";
      };

      network = {
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        nospacing = 1;
        on-click = "ghostty -e nmcli";
      };

      wireplumber = {
        format = "";
        format-muted = "󰝟";
        scroll-step = 5;
        on-click = "pavucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip-format = "Playing at {volume}%";
        max-volume = 150;
      };

      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-connected = "";
        tooltip-format = "Devices connected: {num_connections}";
        on-click = "blueberry";
      };

      battery = {
        interval = 5;
        format = "{capacity}% {icon}";
        format-discharging = "{icon}";
        format-charging = "{icon}";
        format-plugged = "";
        format-full = "Charged ";
        format-icons = {
          charging = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        states = {
          warning = 20;
          critical = 10;
        };
      };

      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}";
        tooltip = true;
        format-icons = {
          power-saver = "󰡳";
          balanced = "󰊚";
          performance = "󰡴";
        };
      };

      tray = {
        spacing = 13;
      };
    };

    style = builtins.readFile ./style.css;
  };
}
