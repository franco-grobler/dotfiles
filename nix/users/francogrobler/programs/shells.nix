{
  isWSL,
}:

{
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;

  shellAliases = {
    cl = "clear";
    ".." = "cd ..";
    "..." = "cd ../..";
    justg = "just --global-justfile";
    l = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    ltree = "eza --tree --level=2  --icons --git";
  }
  // (
    if isWSL then
      {
        pbcopy = "win32yank.exe -i";
        pbpaste = "win32yank.exe -o";
        ssh = "ssh.exe";
        ssh-add = "ssh-add.exe";
      }
    else if isLinux then
      {
        pbcopy = "xclip";
        pbpaste = "xclip -o";
      }
    else
      { }
  );

  appAliases = {
    "go-home" = "cd $HOME";
    "gemini-cli" = "GEMINI_API_KEY=$(op read $GEMINI_API_KEY) gemini";
  }
  // (
    if isDarwin then
      {
        drawio = "$HOME/Applications/draw.io.app/Contents/MacOS/draw.io";
      }
    else
      { }
  );
  appAliasesNu = {
    "go-home" = "cd $env.HOME";
    "gemini-cli" = "GEMINI_API_KEY=$(op read $env.GEMINI_API_KEY) gemini";
  }
  // (
    if isDarwin then
      {
        drawio = "$env.HOME/Applications/draw.io.app/Contents/MacOS/draw.io";
      }
    else
      { }
  );

in
{
  programs = {
    bash = {
      enable = true;
      shellOptions = [ "vi" ];
      historyControl = [
        "ignoredups"
        "ignorespace"
      ];
      shellAliases = shellAliases // appAliases;
    };

    nushell = {
      enable = true;
      settings = {
        edit_mode = "vi";
      };
      shellAliases = shellAliases // appAliasesNu;
    };

    zsh = {
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
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = shellAliases // appAliases;
    };
  };
}
