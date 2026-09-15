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
    terminal = "\${TERM}";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      tmux-fzf
      fzf-tmux-url
      catppuccin
    ];
    extraConfig = ''
      source-file ~/.config/tmux/tmux.reset.conf

      set-option -g allow-passthrough on
      set-option -g terminal-overrides ',xterm*:Tc'

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

      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_directory_text "#{b:pane_current_path}"
      set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
      set -g @catppuccin_window_text "#W"

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
