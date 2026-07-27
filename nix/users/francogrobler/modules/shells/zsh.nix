{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "vicmd";
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      # Dotfiles
      source "$HOME/.config/zsh/zshrc"
    '';
    syntaxHighlighting.enable = true;
  };
}
