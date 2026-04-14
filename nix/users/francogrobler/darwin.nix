{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "cocoapods"
      "gemini-cli"
      "llvm"
      "mole"
    ];
    casks = [
      "1password"
      "adobe-acrobat-reader"
      "alacritty"
      {
        name = "anydesk";
        args = {
          require_sha = false;
        };
      }
      "db-browser-for-sqlite"
      "drawio"
      "ghostty"
      {
        name = "google-chrome";
        args = {
          require_sha = false;
        };
      }
      "inkscape"
      "keka"
      "podman-desktop"
      "slack"
      "skim"
      "vial"
      "qmk-toolbox"
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
      cleanup = "uninstall";
      upgrade = true;
    };
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

  system = {
    defaults = {
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "iCloud Drive";
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      iCal = {
        "TimeZone support enabled" = true;
        "first day of week" = "Monday";
      };
      menuExtraClock = {
        FlashDateSeparators = true;
        IsAnalog = false;
        Show24Hour = true;
        ShowDate = 0;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
        ShowSeconds = true;
      };
      screencapture = {
        location = "~/Desktop/";
        target = "file";
      };
      trackpad = {
        Clicking = true;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
      };
    };
    keyboard = {
      # TODO: This fucks up external keyboards.
      enableKeyMapping = false;
      swapLeftCtrlAndFn = false;
    };
    startup.chime = false;

    # Required for some settings like homebrew to know what user to apply to.
    primaryUser = "francogrobler";
  };

  time.timeZone = "Africa/Johannesburg";

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.francogrobler = {
    description = "Franco Grobler";
    home = "/Users/francogrobler";
    shell = pkgs.zsh;
  };
}
