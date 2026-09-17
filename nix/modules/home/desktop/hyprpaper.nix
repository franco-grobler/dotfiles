# Wallpaper. Ships a Tokyo Night placeholder (restored from the old Everforest
# asset so the session never boots without a background); drop your own
# `tokyo-night.jpg` in this folder to retheme -- hyprpaper picks it up on the
# next switch.
{ config, ... }:
{
  home.file."Pictures/Wallpapers/tokyo-night.jpg".source = ./wallpapers/tokyo-night.jpg;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${config.home.homeDirectory}/Pictures/Wallpapers/tokyo-night.jpg" ];
      wallpaper = [
        ",${config.home.homeDirectory}/Pictures/Wallpapers/tokyo-night.jpg"
      ];
    };
  };
}
