# Work-only macOS apps, merged into the homebrew baseline.
#
# No `masApps`: the App Store is disabled on the work mac, so App Store apps
# would fail activation. Use a cask instead where one exists.
#
# Everything the old setup (branch feat/cloudsmiths) installed is carried over,
# except cursor and `mas`. `gemini-cli` moved to nixpkgs (home/profile/work.nix)
# because its formula is deprecated.
#
# `alacritty` and `vial` are disabled in homebrew (they fail Gatekeeper), so
# brew can't install them fresh. They stay listed because they are already
# installed on this mac, and an installed cask in the Brewfile is a no-op.
{
  homebrew = {
    brews = [
      "cocoapods"
      "mole"
    ];

    casks = [
      "adobe-acrobat-reader"
      "alacritty"
      {
        # Ships without a checksum, so it can't meet the global require_sha.
        name = "anydesk";
        args.require_sha = false;
      }
      "claude"
      "db-browser-for-sqlite"
      "inkscape"
      "keka"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-teams"
      "podman-desktop"
      "qmk-toolbox"
      "skim"
      "sonarqube-cli"
      "vial"
    ];
  };
}
