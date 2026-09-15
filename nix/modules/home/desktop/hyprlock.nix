# Lock screen, bound to $mod+shift+X in hyprland.nix.
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
      };

      background = [
        {
          color = "rgba(29, 31, 33, 1.0)";
          blur_passes = 0;
        }
      ];

      input-field = [
        {
          size = "280, 48";
          position = "0, -80";
          halign = "center";
          valign = "center";
          outline_thickness = 2;
          outer_color = "rgba(178, 148, 187, 1.0)";
          inner_color = "rgba(40, 42, 46, 1.0)";
          font_color = "rgba(197, 200, 198, 1.0)";
          placeholder_text = "";
          fade_on_empty = false;
        }
      ];

      label = [
        {
          text = "$TIME";
          font_size = 64;
          color = "rgba(197, 200, 198, 1.0)";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
