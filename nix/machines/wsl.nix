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
    settings = {
      trusted-users = [
        "root"
        currentSystemUser
      ];
    };
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.stateVersion = "25.05";
}
