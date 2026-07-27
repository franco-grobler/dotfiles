{ pkgs, systemName, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  onePassPath =
    if isDarwin then
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "~/.1password/agent.sock";
  osConfig =
    if isDarwin then
      "darwinConfigurations"
    else if isLinux then
      "nixosConfigurations"
    else
      "homeConfigurations";
in
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 2";
    };
    flake = "$HOME/dotfiles/nix#${osConfig}.${systemName}";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        identityAgent = ''"${onePassPath}"'';
      };

      "GitHub- Personal" = {
        host = "github.com";
        user = "git";
        identityFile = "~/.ssh/github/personal.pub";
        identitiesOnly = true;
      };

      "Bamboo- Norm" = {
        host = "192.168.1.100:8006";
        user = "root";
        port = 22;
      };

      "OpenWRT" = {
        host = "192.168.1.1";
        user = "root";
        port = 22;
      };
    };
  };
}
