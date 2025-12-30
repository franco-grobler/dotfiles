{
  isWSL,
  inputs,
  systemName,
  ...
}:

{
  config,
  colorScheme,
  lib,
  pkgs,
  ...
}:

let
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
      inherit isLinux isWSL;
    })
    (import "${currentDir}/programs/hyprland/default.nix" {
      enable = isLinux && !isWSL;
      inherit pkgs;
    })
    (import "${currentDir}/programs/languages.nix" { inherit pkgs; })
    (import "${currentDir}/programs/shells.nix" { inherit shellAliases; })
    (import "${currentDir}/programs/utils.nix" { inherit osConfig systemName isDarwin; })
    (import "${currentDir}/programs/vsc.nix" { inherit lib pkgs isWSL; })
  ];
  lspPackages = import "${currentDir}/programs/lsps.nix" { inherit pkgs; };
in
{
  home = {
    stateVersion = "25.05";

    # Make cursor not tiny on HiDPI screens
    pointerCursor = lib.mkIf (isLinux && !isWSL) {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 128;
      x11.enable = true;
    };

    #---------------------------------------------------------------------
    # Packages
    #---------------------------------------------------------------------

    # Packages I always want installed. Most packages I install using
    # per-project flakes sourced with direnv and nix-shell, so this is
    # not a huge list.
    packages = [
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
      pkgs.gcc
      pkgs.gh
      pkgs.glow
      pkgs.htop
      pkgs.jaq
      pkgs.just
      pkgs.jq
      pkgs.kubectl
      pkgs.lazydocker
      pkgs.lazygit
      pkgs.luajitPackages.luarocks
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
      pkgs.statix
      pkgs.sentry-cli
      pkgs.stow
      pkgs.sshs
      pkgs.tree
      pkgs.tmux
      pkgs.wget
      pkgs.yazi
      pkgs.yq

      pkgs.nerd-fonts.jetbrains-mono
    ]
    ++ (
      lib.optionals (isLinux || isWSL) [
        pkgs.qemu
        pkgs.virtiofsd
        pkgs.xclip

      ]
      ++ lspPackages
    )
    ++ (lib.optionals (isLinux && !isWSL) [
      # MacOS & WSL installer not available
      pkgs.gemini-cli
      # GUI apps
      pkgs._1password-gui
      pkgs.alacritty
      pkgs.brave
      pkgs.chromium
      pkgs.firefox
      pkgs.freecad-wayland
      pkgs.ghostty
      pkgs.gnome-disk-utility
      pkgs.podman-desktop
      pkgs.rofi
      pkgs.vial
      pkgs.valgrind
      pkgs.zathura
      # hyprland
      pkgs.brightnessctl
      pkgs.gnome-themes-extra
      pkgs.hyprshot
      pkgs.hyprpicker
      pkgs.hyprsunset
      pkgs.pamixer
      pkgs.pavucontrol
      pkgs.playerctl
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
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  imports = globalPrograms;

  programs.gpg.enable = !isDarwin;

  gtk = {
    enable = isLinux;
    theme = {
      name = "Adwaita:dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.file = {
    ".local/share/omarchy/bin" = {
      source = ./programs/hyprland/scripts;
      recursive = true;
    };
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

  xresources.extraConfig = builtins.readFile ./config/Xresources;

  xdg.enable = true;
}
