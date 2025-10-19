{ shellAliases }:
{
  programs.bash = {
    enable = true;
    shellOptions = [ ];
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    shellAliases = shellAliases;
  };

  programs.nushell = {
    enable = true;
    shellAliases = shellAliases;
  };

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    defaultKeymap = "vicmd";
    initContent = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      # Dotfiles
      source "$HOME/.config/zsh/zshrc"
    '';
    shellAliases = shellAliases;
    syntaxHighlighting = {
      enable = true;
    };
  };
}
