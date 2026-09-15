{ features, pkgs, ... }:
{
  imports = [ features.home-manager ];

  users.users.francogrobler = {
    description = "Franco Grobler";
    isNormalUser = true;
    home = "/home/francogrobler";
    shell = pkgs.zsh;
    # colima runs a rootless user VM, so no `docker` group is needed — and
    # nothing here creates one.
    extraGroups = [ "wheel" ];
  };

  programs.zsh.enable = true;
}
