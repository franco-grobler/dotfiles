{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "vicmd";
    dotDir = "${config.xdg.configHome}/zsh";
    syntaxHighlighting.enable = true;
    initContent = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      # Dotfiles
      source "$HOME/.config/zsh/zshrc"
    '';
  };

  xdg.configFile."zsh/zshrc".source = ./zshrc;
}
