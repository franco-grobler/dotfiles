# `nh os switch` / `nh home switch` without having to remember which output
# class this host lives under.
{
  config,
  lib,
  pkgs,
  hostName,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  outputClass =
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
    flake = "${config.dotfiles.root}/nix#${outputClass}.${hostName}";
  };

  # home-manager hands extraArgs to launchd as one argv entry -- systemd splits
  # ExecStart on spaces, launchd does not -- so nh rejects
  # "--keep-since 7d --keep 2" as a single unknown flag and the weekly gc never
  # runs. Split it ourselves.
  launchd.agents.nh-clean.config.ProgramArguments = lib.mkIf isDarwin (
    lib.mkForce (
      [
        (lib.getExe config.programs.nh.package)
        "clean"
        "user"
      ]
      ++ lib.splitString " " config.programs.nh.clean.extraArgs
    )
  );
}
