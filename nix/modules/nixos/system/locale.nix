{
  time.timeZone = "Africa/Johannesburg";

  # The home config exports LANG/LC_ALL=en_ZA.UTF-8; without generating that
  # locale here, every shell on this box starts with a "cannot set LC_ALL"
  # warning and sorting/formatting silently falls back to C.
  i18n = {
    defaultLocale = "en_ZA.UTF-8";
    extraLocales = [ "en_GB.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_CTYPE = "en_ZA.UTF-8";
      LC_ALL = "en_ZA.UTF-8";
    };
  };
}
