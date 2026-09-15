# Personal-only macOS apps, merged into the homebrew baseline.
{
  homebrew = {
    brews = [
      "cocoapods"
      "mole"
    ];

    casks = [
      "balenaetcher"
      "drawio"
      "inkscape"
      "keka"
      "skim"
      "qmk-toolbox"
      "vial"
    ];

    masApps = {
      Numbers = 361304891;
      Vimlike = 1584519802;
      Wireguard = 1451685025;
    };
  };
}
