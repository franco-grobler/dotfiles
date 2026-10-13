# Work MacBook (aarch64). Same toolchain as the personal mac, different identity
# and app set — note it takes `dev` but not `personal`.
#
# The account is `franco.grobler` here; the personal hosts use `francogrobler`.
# That difference is why nothing in the tree hardcodes a username -- it all
# comes back out of `dotfiles.users`.
#
# The filename is the machine's LocalHostName (`scutil --get LocalHostName`),
# which is how `just nix-switch` finds this configuration.
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

  dotfiles.users."franco.grobler" = {
    description = "Franco Grobler";
    modules = with home; [
      base
      dev
      terminal
      monitor
      work
    ];
  };
}
