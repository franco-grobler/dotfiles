{
  _,
  ...
}:
{
  imports = [
    ./modules/shells
    ./modules/editors
    ./modules/clis
    ./modules/tuis
    ./modules/utils
    ./modules/desktop
  ];

  home.stateVersion = "25.05";
  xdg.enable = true;
}
