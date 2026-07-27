{ pkgs, ... }:
{
  system.stateVersion = "25.05";
  environment.localBinInPath = true;
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
}
