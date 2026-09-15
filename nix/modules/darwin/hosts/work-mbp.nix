# Work MacBook (aarch64). Same toolchain as the personal mac, different identity
# and app set — note it takes `dev` but not `personal`, and skips `monitor`.
#
# The account is `franco.grobler` here; the personal hosts use `francogrobler`.
# That difference is why nothing in the tree hardcodes a username -- it all
# comes back out of `dotfiles.users`.
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
  imports = with features; [ base ];

  nixpkgs.pkgs = mkPkgs {
    system = "aarch64-darwin";
    channel = "stable";
  };

  dotfiles.users."franco.grobler" = {
    description = "Franco Grobler";
    modules = with home; [
      base
      dev
      terminal
      work
    ];
  };
}
