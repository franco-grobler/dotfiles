# Shared desktop theme: Tokyo Night everywhere GTK and Qt look.
#
# Hyprland/Waybar/Walker/Mako/Hyprlock carry their own hex (documented at the
# top of each file); this module covers the toolkits that read a theme name
# instead: GTK3/4 via Adwaita:dark, Qt via adwaita-qt, and a dark preference
# so Firefox/Chromium/file pickers follow suit.
{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = config.gtk.theme;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    gnome-themes-extra
  ];
}
