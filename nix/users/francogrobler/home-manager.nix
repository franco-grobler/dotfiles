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
    else if isLinux || isWSL then
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
    else if isDarwin then
      {
        drawio = "$HOME/Applications/draw.io.app/Contents/MacOS/draw.io";
      }
    else
      { }
  );

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  # manpager = (
  #   pkgs.writeShellScriptBin "manpager" (
  #     if isDarwin then
  #       ''
  #         sh -c 'col -bx | bat -l man -p'
  #       ''
  #     else
  #       ''
  #         cat "$1" | col -bx | bat --language man --style plain
  #       ''
  #   )
  # );

  currentDir = builtins.path { path = ./.; };

  globalPrograms = [
    (import "${currentDir}/programs/clis.nix")
    (import "${currentDir}/programs/i3.nix" {
      isLinux = isLinux;
      isWSL = isWSL;
    })
    (import "${currentDir}/programs/languages.nix" { inherit pkgs; })
    (import "${currentDir}/programs/shells.nix" { inherit shellAliases; })
    (import "${currentDir}/programs/tuis.nix")
    (import "${currentDir}/programs/utils.nix" {
      inherit osConfig systemName isDarwin;
    })
    (import "${currentDir}/programs/vsc.nix")
  ];
  lspPackages = import "${currentDir}/programs/lsps.nix" { inherit pkgs; };
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
      pkgs.devbox
      pkgs.devenv
      pkgs.docker
      pkgs.duf
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
      pkgs.gemini-cli # macos installer not available
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

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs._1password-cli
    pkgs.awscli2
    pkgs.bat
    pkgs.bottom
    pkgs.btop
    pkgs.cmatrix
    pkgs.cowsay
    pkgs.devenv
    pkgs.dive
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
    pkgs.kubectl
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.lolcat
    pkgs.neovim
    pkgs.nodejs
    pkgs.nixfmt-rfc-style
    pkgs.ookla-speedtest
    pkgs.podman
    pkgs.podman-compose
    pkgs.podman-tui
    pkgs.python314
    pkgs.qmk
    pkgs.ripgrep
    pkgs.rustup
    pkgs.sentry-cli
    pkgs.stow
    pkgs.sshs
    pkgs.thefuck
    pkgs.tree
    pkgs.tmux
    pkgs.wget
    pkgs.yazi
    pkgs.yq

    pkgs.nerd-fonts.jetbrains-mono
  ]
  ++ (lib.optionals (isLinux || isWSL) [
    pkgs.qemu
    pkgs.virtiofsd
    pkgs.xclip
  ])
  ++ (lib.optionals (isLinux && !isWSL) [
    # MacOS & WSL installer not available
    pkgs.gemini-cli
    # GUI apps
    pkgs._1password-gui
    pkgs.alacritty
    pkgs.chromium
    pkgs.firefox
    pkgs.freecad-wayland
    pkgs.ghostty
    pkgs.podman-desktop
    pkgs.rofi
    pkgs.vial
    pkgs.valgrind
    pkgs.zathura
  ])
  ++ lspPackages;

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

      EDITOR = "nvim";
      PAGER = "less -FirSwX";
      PODMAN_COMPOSE_WARNING_LOGS = "false";

      BAT_CONFIG_PATH = "$XDG_CONFIG_HOME/bat/config";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    PODMAN_COMPOSE_WARNING_LOGS = "false";
    # MANPAGER = "${manpager}/bin/manpager";

    GEMINI_API_KEY = "op://Personal/Gemini CLI/credential";
  }
  // (
    if isDarwin then
      {
        # See: https://github.com/NixOS/nixpkgs/issues/390751
        DISPLAY = "nixpkgs-390751";
      }
    else
      {
      }
  );

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  imports = globalPrograms;

  programs.gpg.enable = !isDarwin;

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
