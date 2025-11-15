{
  isWSL,
  inputs,
  systemName,
  ...
}:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  # sources = import ../../nix/sources.nix;
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;

  osConfig =
    if isDarwin then
      "darwinConfigurations"
    else if isLinux then
      "nixosConfigurations"
    else
      "homeConfigurations";

  shellAliases = {
    cl = "clear";
    ".." = "cd ..";
    "..." = "cd ../..";
    justg = "just --global-justfile";
    l = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    ltree = "eza --tree --level=2  --icons --git";

    "gemini-cli" = "GEMINI_API_KEY=$(op read $GEMINI_API_KEY) gemini";
  }
  // (
    if isLinux then
      {
        pbcopy = "xclip";
        pbpaste = "xclip -o";
      }
    else if isDarwin then
      {
        drawio = "$HOME/Applications/draw.io.app/Contents/MacOS/draw.io";
      }
    else
      { }
  );

  currentDir = builtins.path { path = ./.; };

  globalPrograms = [
    (import "${currentDir}/programs/clis.nix" { inherit pkgs; })
    (import "${currentDir}/programs/i3.nix" {
      inherit isLinux;
      inherit isWSL;
    })
    (import "${currentDir}/programs/shells.nix" { inherit shellAliases; })
    (import "${currentDir}/programs/tuis.nix")
    (import "${currentDir}/programs/utils.nix" {
      inherit osConfig systemName isDarwin;
    })
    (import "${currentDir}/programs/vsc.nix")
  ];
in
{
  home = {
    stateVersion = "25.05";

    #---------------------------------------------------------------------
    # Packages
    #---------------------------------------------------------------------
    packages = [
      pkgs._1password-cli
      pkgs.bottom
      pkgs.btop
      pkgs.cmatrix
      pkgs.cowsay
      pkgs.devenv
      pkgs.docker
      pkgs.eza
      pkgs.fastfetch
      pkgs.fd
      pkgs.fzf
      pkgs.gh
      pkgs.glow
      pkgs.htop
      pkgs.jaq
      pkgs.just
      pkgs.jq
      pkgs.lazydocker
      pkgs.lolcat
      pkgs.neovim
      pkgs.nodejs
      pkgs.nixfmt-rfc-style
      pkgs.ookla-speedtest
      pkgs.opencode
      pkgs.podman
      pkgs.podman-compose
      pkgs.podman-tui
      pkgs.python314
      pkgs.qmk
      pkgs.ripgrep
      pkgs.rustup
      pkgs.sentry-cli
      pkgs.statix
      pkgs.stow
      pkgs.sshs
      pkgs.thefuck
      pkgs.tree
      pkgs.tmux
      pkgs.wget
      pkgs.yazi
      pkgs.yq
      pkgs.zoxide

      pkgs.nerd-fonts.jetbrains-mono
    ]
    ++ (lib.optionals (!isWSL && !isDarwin) [
      # GUI apps
      pkgs._1password-gui
      pkgs.alacritty
      pkgs.podman-desktop
    ])
    ++ (lib.optionals (!isDarwin) [
      pkgs.gemini-cli # macos installer not availble
    ])
    ++ (lib.optionals (isLinux && !isWSL) [
      pkgs.chromium
      pkgs.firefox
      pkgs.freecad-wayland
      pkgs.ghostty # macos installer is broken
      pkgs.rofi
      pkgs.vial
      pkgs.valgrind
      pkgs.zathura
    ]);

    #---------------------------------------------------------------------
    # Env vars and dotfiles
    #---------------------------------------------------------------------

    sessionVariables = {
      LANG = "en_ZA.UTF-8";
      LC_CTYPE = "en_ZA.UTF-8";
      LC_ALL = "en_ZA.UTF-8";

      EDITOR = "nvim";
      PAGER = "less -FirSwX";
      PODMAN_COMPOSE_WARNING_LOGS = "false";

      BAT_CONFIG_PATH = "$XDG_CONFIG_HOME/bat/config";

      GEMINI_API_KEY = "op://Personal/Gemini CLI/credential";
    }
    // (
      if isDarwin then
        {
          # See: https://github.com/NixOS/nixpkgs/issues/390751
          DISPLAY = "nixpkgs-390751";
        }
      else
        { }
    );

    # Make cursor not tiny on HiDPI screens
    pointerCursor = lib.mkIf (isLinux && !isWSL) {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 128;
      x11.enable = true;
    };
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  imports = globalPrograms;

  programs.gpg.enable = !isDarwin;

  programs.go = {
    enable = true;
    goPath = "$HOME/.go";
  };

  #---------------------------------------------------------------------
  # Services
  #---------------------------------------------------------------------

  services.gpg-agent = {
    enable = isLinux;
    pinentry.package = pkgs.pinentry-tty;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xdg.enable = true;

  xresources.extraConfig = builtins.readFile ./config/Xresources;
}
