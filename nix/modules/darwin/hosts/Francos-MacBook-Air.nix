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
    francogrobler
    personal
  ];

  nixpkgs.pkgs = mkPkgs {
    system = "aarch64-darwin";
    channel = "stable";
  };

  home-manager.users.francogrobler.imports = with home; [
    base
    dev
    terminal
    monitor
    personal
  ];
}
