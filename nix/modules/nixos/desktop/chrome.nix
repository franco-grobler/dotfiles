# Enterprise policies for Chromium-based browsers on NixOS.
#
# home-manager cannot install extensions into proprietary Google Chrome
# (it writes ~/.config External Extensions, which Chrome ignores), so the
# extension force-list lives here instead. programs.chromium writes both
# /etc/chromium/policies/managed (Chromium) and /etc/opt/chrome/policies/managed
# (Google Chrome) from the same options. The Chrome binary itself is installed
# per-user via home/desktop/browsers/chrome.nix.
{
  programs.chromium = {
    enable = true;
    extensions = [
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
    ];
    extraOpts = {
      # Keep password filling in 1Password, not Chrome's built-in manager.
      PasswordManagerEnabled = false;
      # Wayland-native where the wrapper flags do not already cover it.
      OzonePlatformHint = "auto";
    };
  };
}
