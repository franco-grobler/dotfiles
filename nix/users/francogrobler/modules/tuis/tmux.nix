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
    aggressiveResize = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    keyMode = "vi";
    mouse = true;
    secureSocket = false;
    terminal = "screen-256color";
    prefix = "C-a";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      catppuccin
    ];
    extraConfig = ''
      source-file ~/.config/tmux/tmux.reset.conf

      set-option -g allow-passthrough on
      set-option -g terminal-overrides ',xterm*:Tc'

      set-option -g renumber-windows on
      set-option -g detach-on-destroy off
      set-option -g set-clipboard on
      set-option -g allow-passthrough on

      setw -g mode-keys vi
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      set -g @continuum-restore 'on'
      set -g @resurrect-strategy-nvim 'session'

      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_directory_text "#{b:pane_current_path}"
      set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
      set -g @catppuccin_window_text "#W"

      set -g status-position top
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_date_time}"
    '';
  };

  xdg.configFile."tmux/tmux.reset.conf".source =
    ../../../../../tmux/tmux.reset.conf;
}
