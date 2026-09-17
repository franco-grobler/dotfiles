# Application launcher, Omarchy-style. Walker replaces wofi/rofi as the
# Super+Space launcher and backs the Omarchy menu (`omarchy-menu`,
# Super+Alt+Space) plus clipboard (`:`-style) and dmenu modes.
#
# Tokyo Night theme inherits Walker's default theme; only the colours and
# font are overridden so upstream layout changes keep flowing through.
{
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "tokyo-night";
      force_keyboard_focus = true;
      close_when_open = true;

      placeholders."default" = {
        input = "Search…";
        list = "No results";
      };

      providers = {
        default = [
          "desktopapplications"
          "calc"
          "websearch"
        ];
        empty = [ "desktopapplications" ];
        prefixes = [
          { provider = "clipboard"; prefix = "$"; }
          { provider = "symbols"; prefix = ":"; }
          { provider = "calc"; prefix = "="; }
          { provider = "finder"; prefix = "."; }
          { provider = "providerlist"; prefix = "/"; }
        ];
      };

      keybinds = {
        quick_activate = [
          "F1"
          "F2"
          "F3"
        ];
      };
    };

    themes."tokyo-night" = {
      style = ''
        /* Tokyo Night: bg #1a1b26, fg #c0caf5, muted #565f89,
           blue #7aa2f7, border #3b4261. Inherits Walker's default layout. */
        @define-color window_bg_color #1a1b26;
        @define-color accent_bg_color #7aa2f7;
        @define-color theme_fg_color #c0caf5;
        @define-color theme_text_color #c0caf5;
        @define-color insensitive_fg_color #565f89;

        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 14px;
        }

        #window {
          background-color: @window_bg_color;
          border: 2px solid #3b4261;
          border-radius: 8px;
        }

        #input {
          background-color: #16161e;
          color: @theme_fg_color;
          padding: 10px;
        }

        #list {
          background-color: @window_bg_color;
        }

        #item:selected {
          background-color: #292e42;
          border-left: 2px solid @accent_bg_color;
        }

        #item:selected #label {
          color: #7aa2f7;
        }

        #label {
          color: @theme_fg_color;
        }

        #sub {
          color: #565f89;
        }
      '';
    };
  };
}
