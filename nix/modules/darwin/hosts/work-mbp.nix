# Work MacBook (aarch64). Same toolchain as the personal mac, different identity
# and app set — note it takes `dev` but not `personal`, and skips `monitor`.
#
# TODO(franco): rename this file to the machine's real LocalHostName
# (`scutil --get LocalHostName`); the filename is the configuration name.
{
  features,
  home,
  mkPkgs,
  ...
}:
{
  imports = with features; [
    base
    work
  ];

  nixpkgs.pkgs = mkPkgs {
    system = "aarch64-darwin";
    channel = "stable";
  };

  dotfiles.users.francogrobler = {
    description = "Franco Grobler";
    modules = with home; [
      base
      dev
      terminal
      work
    ];
  };
}
