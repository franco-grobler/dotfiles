{ pkgs, ... }:
{
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  programs.zsh.enable = true;

  users.users.francogrobler = {
    isNormalUser = true;
    home = "/home/franco.grobler";
    extraGroups = [
      "docker"
      "lxd"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
