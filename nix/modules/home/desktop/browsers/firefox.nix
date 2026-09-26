# Firefox and Zen (both Firefox-based) with the same force-installed
# extensions: Vimium and 1Password from AMO.
{ config, inputs, ... }:
let
  # Force-install one AMO extension by slug, e.g. "vimium-ff".
  mkAmoExtension = slug: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
    installation_mode = "force_installed";
  };

  # Same extensions in every Firefox-based browser.
  firefoxExtensionSettings = {
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = mkAmoExtension "vimium-ff"; # Vimium
    "{d634138d-c276-4fc8-924b-40a0ea21d284}" =
      mkAmoExtension "1password-x-password-manager"; # 1Password
  };

  # Prefs both Firefox and Zen want. The vaapi pair turns on hardware video
  # decode, which needs hardware.graphics.extraPackages to supply the iHD
  # driver (see nixos/desktop/hyprland.nix); without it these are inert.
  sharedFirefoxSettings = {
    # New extensions land enabled, no manual click in about:addons.
    "extensions.autoDisableScopes" = 0;
    "browser.theme.color-scheme" = 1;
    "media.ffmpeg.vaapi.enabled" = true;
    "media.hardware-video-decoding.force-enabled" = true;
  };

  sharedFirefoxPolicies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    # Zen is the system default; stop Firefox asking to take over.
    DontCheckDefaultBrowser = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    ExtensionSettings = firefoxExtensionSettings;
  };
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.firefox = {
    enable = true;
    # XDG location (the 26.05 default): profiles live under
    # ~/.config/mozilla/firefox. Move ~/.mozilla/firefox there on each machine
    # that has one -- Firefox starts blank until you do -- and leave the rest
    # of ~/.mozilla (e.g. native-messaging-hosts) where it is.
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = sharedFirefoxPolicies;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = sharedFirefoxSettings // {
        "browser.theme.toolbar-theme" = 0;
      };
    };
  };

  programs.zen-browser = {
    enable = true;
    policies = sharedFirefoxPolicies // {
      DisableAppUpdate = true;
    };
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = sharedFirefoxSettings;
    };
  };
}
