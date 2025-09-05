{
  pkgs,
  currentSystemUser,
  ...
}:
{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    openssl
  ];

  wsl = {
    enable = true;
    wslConf = {
      automount = {
        root = "/mnt";
      };
    };
    defaultUser = currentSystemUser;
    docker-desktop.enable = true;
    startMenuLaunchers = true;
    wslConf = {
      automount = {
        root = "/mnt";
      };
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.stateVersion = "25.05";
}
