{
  config,
  pkgs,
  ...
}:
let
  selected_wallpaper_path = "~/Pictures/Wallpapers/everforest.jpg";
in
{
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../assets/wallpapers;
      recursive = true;
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        selected_wallpaper_path
      ];
      wallpaper = [
        ",${selected_wallpaper_path}"
      ];
    };
  };
}
