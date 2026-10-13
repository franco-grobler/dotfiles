# The homebrew baseline every mac gets. Role-specific apps are added by the
# personal / work profiles, which merge into these same lists.
#
# No `masApps` here: the work mac has the App Store disabled, so anything from
# it (and `mas` itself) lives in profile/personal.nix.
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
      "claude-code@latest"
      "figma"
      "ghostty"
      "google-chrome"
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
