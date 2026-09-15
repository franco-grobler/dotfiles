# Personal MacBook Air (aarch64).
{
  features,
  home,
  mkPkgs,
  ...
}:
{
  imports = with features; [
    base
    personal
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
      monitor
      personal
    ];
  };
}
