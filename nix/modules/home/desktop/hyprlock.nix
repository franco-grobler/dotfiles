# Lock screen, Tokyo Night. Bound to Super+Escape in hyprland.nix and driven
# by hypridle.nix after 5 minutes idle.
#
# Palette: bg #1a1b26, fg #c0caf5, blue #7aa2f7, red #f7768e, green #9ece6a.
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        no_fade_in = false;
        hide_cursor = true;
        grace = 2;
      };

      auth = {
        "fingerprint:enabled" = true;
      };

      background = [
        {
          monitor = "";
          path = "~/Pictures/Wallpapers/tokyo-night.jpg";
          blur_passes = 2;
          blur_size = 5;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "280, 48";
          position = "0, -80";
          halign = "center";
          valign = "center";
          outline_thickness = 2;
          outer_color = "rgba(122, 162, 247, 1.0)";
          inner_color = "rgba(26, 27, 38, 1.0)";
          font_color = "rgba(192, 202, 245, 1.0)";
          check_color = "rgba(158, 206, 106, 1.0)";
          fail_color = "rgba(247, 118, 142, 1.0)";
          fade_on_empty = false;
          placeholder_text = "";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 64;
          color = "rgba(192, 202, 245, 1.0)";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
