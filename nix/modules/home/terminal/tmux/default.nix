{ config, pkgs, ... }:
let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "franco-grobler";
      repo = "tmux-catppuccin";
      rev = "main";
      sha256 = "vBYBvZrMGLpMU059a+Z4SEekWdQD0GrDqBQyqfkEHPg=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    keyMode = "vi";
    mouse = true;
    secureSocket = false;
    # default-terminal describes the terminal tmux *emulates* for the programs
    # inside it, not the one it is running in. Passing the outer ${TERM} through
    # makes those programs believe they are talking to Ghostty directly and emit
    # sequences tmux does not implement, which renders as subtly wrong colours.
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      tmux-fzf
      fzf-tmux-url
      # catppuccin builds window-status-format and the theme palette at
      # run-shell time, so every @catppuccin_* option has to be set *before*
      # the plugin loads. Home Manager emits a plugin's own extraConfig ahead
      # of its run-shell line; the global extraConfig below runs after every
      # plugin, which is far too late.
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_window_text "#W"

          # The *_current_* separators are derived from the plain ones with
          # `set -ogqF`, i.e. only-if-unset, so they survive a re-source and
          # keep whatever the last load computed. Switching style (or reloading
          # after fixing one) otherwise leaves the current window wearing the
          # old style's separators. Clear them so each source-file recomputes.
          set -guq @catppuccin_window_current_left_separator
          set -guq @catppuccin_window_current_middle_separator
          set -guq @catppuccin_window_current_right_separator
        '';
      }
    ];
    extraConfig = ''
      source-file ~/.config/tmux/tmux.reset.conf

      set-option -g allow-passthrough on
      # Truecolor is a property of the *outer* terminal, so it is declared with
      # terminal-features keyed on the client's TERM. RGB supersedes the older
      # Tc override, and -as appends rather than clobbering tmux's own defaults.
      set-option -as terminal-features ',xterm*:RGB'
      set-option -as terminal-features ',*ghostty*:RGB'

      set-option -g renumber-windows on
      set-option -g detach-on-destroy off
      set-option -g set-clipboard on

      setw -g mode-keys vi
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      # nixpkgs pins resurrect to 2022-05-01, which predates its XDG support and
      # defaults to ~/.tmux/resurrect. The existing save history lives under
      # XDG_DATA_HOME, so point it there or every restore silently finds nothing.
      set -g @resurrect-dir "${config.xdg.dataHome}/tmux/resurrect"

      # Save-only: continuum keeps a 15-minute snapshot history as a crash net,
      # but no longer respawns every pane at server start. Sessions come back
      # on demand via sesh/tmuxinator instead. Restore a snapshot deliberately
      # with resurrect's own binding (prefix + C-r).
      set -g @continuum-restore 'off'
      set -g @resurrect-strategy-nvim 'session'

      set -g status-position top
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_date_time}"

      # Home Manager emits plugin run-shell lines *before* extraConfig, so the
      # status-right above wipes the #{continuum_save} hook that continuum
      # appends there -- which silently stops all automatic saving. Re-run
      # continuum last so it re-arms against the final status-right.
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };

  xdg.configFile."tmux/tmux.reset.conf".source = ./tmux.reset.conf;
}
