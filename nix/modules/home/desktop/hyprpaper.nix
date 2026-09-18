# Wallpaper. Nanga Parbat under a night sky: near-black foreground and a navy
# gradient that sits with the Tokyo Night background (#1a1b26), so windows and
# the bar stay readable on top of it. 3840x2543.
#   https://images.unsplash.com/photo-1574610758891-5b809b6e6e2e (Unsplash License)
# Drop your own `tokyo-night.jpg` in this folder to retheme; hyprpaper picks it
# up on the next switch.
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
