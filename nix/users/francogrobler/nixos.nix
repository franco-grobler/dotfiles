{ pkgs, ... }:
{
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
    libraries = with pkgs; [ ruff ];
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

  services.fprintd.enable = true;

  time.timeZone = "Africa/Johannesburg";

  virtualisation = {
    containers = {
      enable = true;
      containersConf = {
        settings = {
          compose_warning_logs = false;
        };
      };
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
