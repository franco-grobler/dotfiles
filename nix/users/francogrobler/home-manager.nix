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
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;

  osConfig =
    if isDarwin then
      "darwinConfigurations"
    else if isLinux || isWSL then
      "nixosConfigurations"
    else
      "homeConfigurations";

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
    (import "${currentDir}/programs/clis.nix" { inherit pkgs; })
    (import "${currentDir}/programs/i3.nix" {
      inherit isLinux;
      inherit isWSL;
    })
    (import "${currentDir}/programs/shells.nix" { inherit shellAliases; })
    (import "${currentDir}/programs/tuis.nix")
    (import "${currentDir}/programs/utils.nix" {
      inherit
        config
        osConfig
        systemName
        isDarwin
        ;
    })
    (import "${currentDir}/programs/vsc.nix" { inherit lib pkgs isWSL; })
  ];
  lspPackages = import "${currentDir}/programs/lsps.nix" { inherit pkgs; };
in
{
  home = {
    stateVersion = "25.05";

    #---------------------------------------------------------------------
    # Packages
    #---------------------------------------------------------------------
    packages =
      with pkgs;
      [
        _1password-cli
        bottom
        btop
        chafa
        cmatrix
        cowsay
        devbox
        devenv
        docker
        duf
        eza
        fastfetch
        fd
        fzf
        gh
        glow
        htop
        just
        jq
        jqp
        lazydocker
        lolcat
        neovim
        nodejs
        nixfmt-rfc-style
        ookla-speedtest
        opencode
        podman
        podman-compose
        podman-tui
        posting
        python314
        qmk
        ripgrep
        rustup
        sentry-cli
        statix
        stow
        sshs
        tree
        tmux
        wget
        yazi
        yq
        zoxide

        nerd-fonts.jetbrains-mono
      ]
      ++ (lib.optionals (!isWSL && !isDarwin) [
        # GUI apps
        _1password-gui
        alacritty
        podman-desktop
      ])
      ++ (lib.optionals (!isDarwin) [
        gemini-cli # macos installer not available
      ])
      ++ (lib.optionals (isLinux && !isWSL) [
        chromium
        firefox
        freecad-wayland
        ghostty # macos installer is broken
        rofi
        vial
        valgrind
        zathura
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
