{ pkgs, ... }: {
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  i18n = {
    defaultLocale = "en_ZA.UTF-8";

    extraLocales = [ "en_GB.UTF-8/UTF-8" ];

    extraLocaleSettings = {
      LC_CTYPE = "en_ZA.UTF-8";
      LC_ALL = "en_ZA.UTF-8";
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ markdown-toc ruff ];
  };

  programs.zsh.enable = true;

  users.users.francogrobler = {
    isNormalUser = true;
    home = "/home/francogrobler";
    extraGroups = [
      "docker"
      "lxd"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  time.timeZone = "Africa/Johannesburg";
}
