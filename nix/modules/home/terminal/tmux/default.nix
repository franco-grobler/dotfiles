{ config, pkgs, ... }:
let
  # Resolve through Nix rather than hardcoding ~/.config and ~/.local/share,
  # so the config still works if XDG_CONFIG_HOME/XDG_DATA_HOME are moved.
  tmuxConfigDir = "${config.xdg.configHome}/tmux";
  tmuxDataDir = "${config.xdg.dataHome}/tmux";
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
    # The terminal tmux *emulates* for the programs inside it, not the one it
    # is running in. Passing the outer $TERM through makes those programs
    # believe they are talking to Ghostty directly and emit sequences tmux
    # does not implement, which renders as subtly wrong colours.
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      tmux-fzf
      fzf-tmux-url
    ];

    # The static settings live in tmux.conf; only the lines that need a path
    # or a store path are built here.
    extraConfig = builtins.readFile ./tmux.conf + ''

      # nixpkgs pins resurrect to 2022-05-01, which predates its XDG support
      # and defaults to ~/.tmux/resurrect. The existing save history lives
      # under XDG_DATA_HOME, so point it there or every restore silently
      # finds nothing.
      set -g @resurrect-dir "${tmuxDataDir}/resurrect"

      source-file ${tmuxConfigDir}/theme.conf
      source-file ${tmuxConfigDir}/keybindings.conf

      # Reload the Home Manager-generated entrypoint, not this fragment.
      bind R source-file ${tmuxConfigDir}/tmux.conf

      # Must stay last. Home Manager emits plugin run-shell lines *before*
      # extraConfig, so the status-right in theme.conf wipes the
      # #{continuum_save} hook that continuum appends there -- which silently
      # stops all automatic saving. Re-run continuum here so it re-arms
      # against the final status-right.
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };

  xdg.configFile = {
    "tmux/theme.conf".source = ./theme.conf;
    "tmux/keybindings.conf".source = ./keybindings.conf;
  };
}
