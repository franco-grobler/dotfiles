# Personal-only macOS apps, merged into the homebrew baseline.
{ config, features, ... }:
{
  imports = with features; [ samba-mount ];

  dotfiles.sambaMount = {
    server = "router.trusted.lab.bamboo.grobler.fyi";
    share = "data";
    mountPoint = "${
      config.users.users.${config.system.primaryUser}.home
    }/Network/Bamboo-Share";
  };

  homebrew = {
    brews = [
      "cocoapods"
      "mas"
      "mole"
    ];

    casks = [
      "balenaetcher"
      "claude"
      "drawio"
      "freecad"
      "inkscape"
      "keka"
      "skim"
      "qmk-toolbox"
      "vial"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      Numbers = 361304891;
      Vimlike = 1584519802;
      Wireguard = 1451685025;
    };
  };
}
