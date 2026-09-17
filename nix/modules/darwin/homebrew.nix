# The homebrew baseline every mac gets. Role-specific apps are added by the
# personal / work profiles, which merge into these same lists.
{
  homebrew = {
    enable = true;

    brews = [
      "anomalyco/tap/opencode"
      "colima"
      "container"
      "llvm"
      "mas"
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

    masApps."1Password for Safari" = 1569813296;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
    };

    taps = [
      "anomalyco/tap"
    ];
  };
}
