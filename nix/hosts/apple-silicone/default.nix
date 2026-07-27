{ pkgs, ... }:
{
  system.stateVersion = 6;

  ids.gids.nixbld = 30000;

  nix = {
    enable = false;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    settings = {
      trusted-users = [
        "root"
        "francogrobler"
      ];
      extra-substituters = "https://devenv.cachix.org";
      extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    };
  };

  homebrew = {
    enable = true;
    brews = [
      "cocoapods"
      "colima"
      "container"
      "llvm"
      "mas"
      "mole"
    ];
    casks = [
      "1password"
      "balenaetcher"
      "claude-code@latest"
      "drawio"
      "ghostty"
      "google-chrome"
      "inkscape"
      "keka"
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
    masApps = {
      "1Password for Safari" = 1569813296;
      Numbers = 361304891;
      Vimlike = 1584519802;
      Wireguard = 1451685025;
    };
    onActivation = {
      autoUpdate = false;
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
        ShowHardDrivesOnDesktop = false;
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
        location = "~/Desktop/Screenshots";
        target = "file";
      };
      trackpad = {
        Clicking = true;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = false;
      swapLeftCtrlAndFn = false;
    };
    startup.chime = false;
    primaryUser = "francogrobler";
  };

  time.timeZone = "Africa/Johannesburg";

  users.users.francogrobler = {
    description = "Franco Grobler";
    home = "/Users/francogrobler";
    shell = pkgs.zsh;
  };
}
