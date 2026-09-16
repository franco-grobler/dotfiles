{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    dotDir = "${config.xdg.configHome}/zsh";
    syntaxHighlighting.enable = true;
    initContent = ''
      # hm-session-vars.sh guards itself with __HM_SESS_VARS_SOURCED, which is
      # exported and therefore inherited by every child process. Long-lived
      # parents (the tmux server, Ghostty) keep that flag set across a rebuild,
      # so shells they spawn skip the guard and keep the *old* values of
      # STARSHIP_CONFIG, EDITOR, etc. Re-source it unconditionally.
      unset __HM_SESS_VARS_SOURCED
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"

      # Dotfiles
      source "${config.xdg.configHome}/zsh/zshrc"
    '';
  };

  xdg.configFile."zsh/zshrc".source = ./zshrc;
}
