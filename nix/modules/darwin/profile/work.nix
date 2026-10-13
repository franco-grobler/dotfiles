# Work-only macOS apps, merged into the homebrew baseline.
#
# No `masApps`: the App Store is disabled on the work mac, so App Store apps
# would fail activation. Use a cask instead where one exists.
{
  homebrew = {
    brews = [
      "cocoapods"
      "mole"
    ];

    casks = [
      "claude"
      "qmk-toolbox"
      "vial"
    ];
  };
}
