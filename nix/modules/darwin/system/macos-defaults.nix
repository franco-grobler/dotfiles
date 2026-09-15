{
  system.defaults = {
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

  system.keyboard = {
    enableKeyMapping = false;
    swapLeftCtrlAndFn = false;
  };

  system.startup.chime = false;
}
