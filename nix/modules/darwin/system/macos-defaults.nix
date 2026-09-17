{
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
        TrackpadThreeFingerDrag = false;
      };

      # Three-finger swipe between spaces. macOS gives the three-finger gesture
      # to drag or to swipe, not both, so TrackpadThreeFingerDrag is off above.
      # Set on both trackpad domains; nix-darwin has no option for these keys.
      CustomUserPreferences =
        let
          swipe = {
            TrackpadThreeFingerHorizSwipeGesture = 2;
            TrackpadFourFingerHorizSwipeGesture = 0;
          };
        in
        {
          "com.apple.AppleMultitouchTrackpad" = swipe;
          "com.apple.driver.AppleBluetoothMultitouch.trackpad" = swipe;
        };
    };

    keyboard = {
      enableKeyMapping = false;
      swapLeftCtrlAndFn = false;
    };

    startup.chime = false;
  };
}
