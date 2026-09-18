# Hyprland configuration, Omarchy-style on Nix.
#
# The compositor binary itself is installed by the NixOS module
# (nixos/desktop/hyprland.nix); `package = null` here stops home-manager from
# pulling in a second copy that would disagree with the session file.
#
# Layout follows Omarchy 3.x: default apps, keybindings, look-and-feel,
# autostart, env vars, input and window rules in one file so the whole desktop
# can be reasoned about at once. The *theme* (Tokyo Night) lives in the
# sibling modules -- waybar/style.css, walker, mako, hyprlock -- using the
# same hex values documented at the top of each file.
{ lib, pkgs, ... }:
let
  workspaces = builtins.genList (i: toString (i + 1)) 9;

  workspaceBinds = lib.concatMap (n: [
    "SUPER, ${n}, workspace, ${n}"
    "SUPER SHIFT, ${n}, movetoworkspace, ${n}"
  ]) workspaces;

  # hjkl everywhere: shell, tmux, and now window focus / movement.
  directions = {
    h = "l";
    j = "d";
    k = "u";
    l = "r";
  };
  focusBinds = lib.mapAttrsToList (key: dir: "SUPER, ${key}, movefocus, ${dir}") directions;
  moveBinds = lib.mapAttrsToList (
    key: dir: "SUPER SHIFT, ${key}, movewindow, ${dir}"
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
      "$browser" = "chromium --new-window --ozone-platform=wayland";
      "$fileManager" = "nautilus --new-window";
      "$passwordManager" = "1password";
      "$menu" = "walker";
      "$omarchyMenu" = "omarchy-menu";
      "$webapp" = "chromium --new-window --ozone-platform=wayland --app";

      # Use whatever the display reports; override per-monitor once you know
      # the output names (`hyprctl monitors`).
      monitor = ",preferred,auto,1";

      # Session services. hyprpaper/hypridle/mako are started by their own
      # systemd user units (home-manager, wanted by graphical-session.target),
      # so they must NOT be listed here -- a second mako cannot take the
      # org.freedesktop.Notifications bus name and dies on startup. exec-once
      # only covers what has no unit: the bar, tray apps, clipboard and OSD.
      exec-once = [
        "waybar"
        "hyprsunset"
        "swayosd-server"
        "systemctl --user start hyprpolkitagent"
        "wl-clip-persist --clipboard regular & clipse -listen"
        "1password --silent"
        # The Xft settings in xresources/Xresources only reach XWayland apps if
        # something loads them.
        "xrdb -merge ~/.Xresources"
      ];

      # NOTE: no `exec` block. Hyprland queues `exec` entries into the same
      # first-launch list as `exec-once` (it only differs on reload), so
      # "pkill -SIGUSR2 waybar || waybar" started a *second* bar at login.
      # Restart the bar by hand after a reload if you need to.

      # Hyprland's `env` is a plain setenv(): the value is taken literally,
      # with no shell expansion. Anything that needs to *append* to an existing
      # variable therefore cannot live here -- "$XDG_DATA_DIRS:..." exported the
      # dollar sign verbatim and destroyed the session's data dirs, which is
      # what emptied Walker, hid every icon and made GTK apps abort on missing
      # gsettings schemas. NixOS already puts /run/current-system/sw/share and
      # /etc/profiles/per-user/$USER/share on XDG_DATA_DIRS for the session.
      #
      # Cursor theme/size belongs to pointer.nix and the GTK theme to theme.nix;
      # setting them again here just gave the desktop two disagreeing answers.
      # HiDPI is a per-monitor `scale` in the `monitor` line above, never
      # GDK_SCALE -- that scaled GTK apps a second time on top of the
      # compositor and is why everything came up twice the size it should be.
      env = [
        # Force all apps onto Wayland where they support it.
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"
        "CHROMIUM_FLAGS,\"--enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4\""

        "EDITOR,nvim"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      ecosystem = {
        # Don't show the update popup on first launch.
        no_update_news = true;
      };

      # Tokyo Night: active #7aa2f7, inactive #3b4261.
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(7aa2f7aa)";
        "col.inactive_border" = "rgba(3b4261aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        shadow = {
          enabled = false;
          range = 30;
          render_power = 3;
          color = "rgba(00000045)";
        };
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 3, easeOutQuint, slide"
        ];
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      input = {
        kb_layout = "us";
        kb_options = "compose:caps";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      # NOTE: no `gestures` block. Hyprland 0.51 replaced the old
      # `gestures:workspace_swipe` toggle with the `gesture` keyword, and an
      # unknown key is a hard config error -- that is the red banner on login.
      # Trackpad gestures are opt-in now, e.g.:
      #   gesture = 3, horizontal, workspace

      # Hyprland 0.55 parses window rules as v3: each comma-separated element is
      # `<name> <value>`, and matchers are prefixed with `match:`. The old
      # `float, class:^(x)$` form reads as an effect with no value and is
      # rejected, so every rule here was dead. `windowrulev2` is gone too.
      # https://wiki.hypr.land/Configuring/Window-Rules/
      windowrule = [
        "suppress_event maximize, match:class .*"

        # Chromium --app windows report as bare chromium; keep them tiled.
        "tile true, match:class ^(chromium)$"

        # Settings / pickers float.
        "float true, match:class ^(org.pulseaudio.pavucontrol|blueman-manager)$"
        "float true, match:class ^(steam)$"
        "fullscreen true, match:class ^(com.libretro.RetroArch)$"

        # A dash of transparency; opaque where it matters (video, games).
        "opacity 0.97 0.9, match:class .*"
        "opacity 1 1, match:class ^(chromium|google-chrome|google-chrome-unstable)$, match:title .*[Yy]outube.*"
        "opacity 1 0.97, match:class ^(chromium|google-chrome|google-chrome-unstable)$"
        "opacity 0.97 0.9, match:initial_class ^(chrome-.*-Default)$"
        "opacity 1 1, match:initial_class ^(chrome-youtube.*-Default)$"
        "opacity 1 1, match:class ^(zoom|vlc|org.kde.kdenlive|com.obsproject.Studio)$"
        "opacity 1 1, match:class ^(com.libretro.RetroArch|steam)$"

        # Fix some dragging issues with XWayland.
        "no_focus true, match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false"

        # Clipboard manager floats centered and keeps focus.
        "float true, match:class (clipse)"
        "size 622 652, match:class (clipse)"
        "stay_focused true, match:class (clipse)"
      ];

      # Same v3 syntax as windowrule; layers match on `namespace`.
      layerrule = [
        # Proper background blur for the launcher and bar.
        "blur true, match:namespace walker"
        "blur true, match:namespace waybar"
      ];

      bind =
        [
          # Default apps (Omarchy-style).
          "SUPER, Return, exec, $terminal"
          "SUPER, F, exec, $fileManager"
          "SUPER, B, exec, $browser"
          "SUPER, N, exec, $terminal -e nvim"
          "SUPER, T, exec, $terminal -e btop"
          "SUPER, D, exec, $terminal -e lazydocker"
          "SUPER, slash, exec, $passwordManager"
          "SUPER, Y, exec, $webapp=https://youtube.com/"

          # Launcher + Omarchy menu (Walker replaces wofi/rofi).
          "SUPER, Space, exec, $menu"
          "SUPER ALT, Space, exec, $omarchyMenu"
          "SUPER SHIFT, Space, exec, pkill -SIGUSR1 waybar"
          # Super+? -- Super+K would collide with the hjkl focus bind below.
          "SUPER SHIFT, slash, exec, omarchy-show-keybindings"
          "CTRL SUPER, V, exec, ghostty --class clipse -e clipse"

          # Window management.
          "SUPER, W, killactive,"
          "SUPER, Backspace, killactive,"
          "SUPER, V, togglefloating,"
          # Not Super+J: that is movefocus down (hjkl, appended below).
          "SUPER, E, layoutmsg, togglesplit"
          "SUPER, P, pseudo,"
          # Not Super+Shift+Plus: same physical key as Super+Shift+equal below.
          "SUPER SHIFT, F, fullscreen,"

          # Move focus with arrows (Omarchy) -- hjkl appended below.
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # Swap windows with SHIFT + arrows (Omarchy).
          "SUPER SHIFT, left, swapwindow, l"
          "SUPER SHIFT, right, swapwindow, r"
          "SUPER SHIFT, up, swapwindow, u"
          "SUPER SHIFT, down, swapwindow, d"

          # Workspace navigation beyond 1-9.
          "SUPER, comma, workspace, -1"
          "SUPER, period, workspace, +1"

          # Resize the active window.
          "SUPER, minus, resizeactive, -100 0"
          "SUPER, equal, resizeactive, 100 0"
          "SUPER SHIFT, minus, resizeactive, 0 -100"
          "SUPER SHIFT, equal, resizeactive, 0 100"

          # Scroll through workspaces.
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"

          # Floating special workspace (scratchpad).
          "SUPER, S, togglespecialworkspace, magic"
          "SUPER SHIFT, S, movetoworkspace, special:magic"

          # Session: lock, exit, reboot, power off.
          "SUPER, Escape, exec, hyprlock"
          "SUPER SHIFT, Escape, exit,"
          "SUPER CTRL, Escape, exec, reboot"
          "SUPER SHIFT CTRL, Escape, exec, systemctl poweroff"

          # Screenshots (hyprshot) + quick region copy.
          ", Print, exec, hyprshot -m region"
          "SHIFT, Print, exec, hyprshot -m window"
          "CTRL, Print, exec, hyprshot -m output"

          # Colour picker.
          "SUPER, Print, exec, hyprpicker -a"
        ]
        ++ focusBinds
        ++ moveBinds
        ++ workspaceBinds
        ++ [
          "SUPER, 0, workspace, 10"
          "SUPER SHIFT, 0, movetoworkspace, 10"
        ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # e = repeat while held. swayosd-client raises the OSD; the volume /
      # brightness itself is applied by the same call.
      bindel = [
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume +5"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume -5"
        ",XF86MonBrightnessUp, exec, swayosd-client --brightness +5"
        ",XF86MonBrightnessDown, exec, swayosd-client --brightness -5"
      ];

      # l = works while locked.
      bindl = [
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    clipse
    grim
    hyprpicker
    hyprshot
    hyprsunset
    playerctl
    slurp
    swayosd
    wl-clip-persist
    wl-clipboard
    xrdb
  ];
}
