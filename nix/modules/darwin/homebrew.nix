# The homebrew baseline every mac gets. Role-specific apps are added by the
# personal / work profiles, which merge into these same lists.
#
# No `masApps` here: the work mac has the App Store disabled, so anything from
# it (and `mas` itself) lives in profile/personal/.
{
  homebrew = {
    enable = true;

    brews = [
      "anomalyco/tap/opencode"
      "colima"
      "container"
      "llvm"
    ];

    casks = [
      "1password"
      "claude-code"
      "figma"
      "ghostty"
      {
        # Ships without a checksum, so it can't meet the global require_sha.
        name = "google-chrome";
        args.require_sha = false;
      }
      "slack"
    ];

    caskArgs = {
      appdir = "~/Applications";
      language = "en-ZA,en-GB";
      require_sha = true;
    };

    global = {
      autoUpdate = false;
      brewfile = true;
    };

    onActivation = {
      autoUpdate = false;
      upgrade = true;
    };

    taps = [
      "anomalyco/tap"
    ];
  };
}
