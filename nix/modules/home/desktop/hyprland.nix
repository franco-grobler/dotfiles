# Hyprland configuration. The compositor itself is installed by the NixOS module
# (nixos/desktop/hyprland.nix); setting `package = null` here stops home-manager
# from pulling in a second copy that would disagree with the session file.
{ lib, pkgs, ... }:
let
  workspaces = builtins.genList (i: toString (i + 1)) 9;

  # $mod + N focuses workspace N, $mod + shift + N throws the window there.
  workspaceBinds = lib.concatMap (n: [
    "$mod, ${n}, workspace, ${n}"
    "$mod SHIFT, ${n}, movetoworkspace, ${n}"
  ]) workspaces;

  # Directions are hjkl, to match the shell and tmux.
  directions = {
    h = "l";
    j = "d";
    k = "u";
    l = "r";
  };
  focusBinds = lib.mapAttrsToList (
    key: dir: "$mod, ${key}, movefocus, ${dir}"
  ) directions;
  moveBinds = lib.mapAttrsToList (
    key: dir: "$mod SHIFT, ${key}, movewindow, ${dir}"
  ) directions;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    xwayland.enable = true;
    systemd.variables = [ "--all" ];
    # The settings below are hyprlang; pin it rather than inherit the default,
    # which flips to "lua" at stateVersion 26.05.
    configType = "hyprlang";

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$menu" = "rofi -show drun";

      # Use whatever the display reports; override per-monitor once you know
      # the output names (`hyprctl monitors`).
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "mako"
        "1password --silent"
        # The Xft settings in xresources/Xresources only reach XWayland apps if
        # something loads them.
        "xrdb -merge ~/.Xresources"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(b294bbee)";
        "col.inactive_border" = "rgba(373b41aa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 6;
        blur.enabled = false;
        shadow.enabled = false;
      };

      animations = {
        enabled = true;
        bezier = [ "snap, 0.05, 0.9, 0.1, 1.0" ];
        animation = [
          "windows, 1, 3, snap"
          "fade, 1, 3, default"
          "workspaces, 1, 3, snap, slide"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Space, exec, $menu"
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod, V, togglefloating,"
        "$mod, P, pseudo,"
        "$mod, T, togglesplit,"
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod SHIFT, X, exec, hyprlock"
        "$mod SHIFT, E, exit,"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      ++ focusBinds
      ++ moveBinds
      ++ workspaceBinds
      ++ [
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # e = repeat while held, l = works while locked.
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    grim
    playerctl
    slurp
    wl-clipboard
    xorg.xrdb
  ];
}
