# Browsers for the linux desktop. Only ever imported on NixOS (see
# desktop/default.nix); macOS GUI browsers come from homebrew casks instead.
#
# Zen (beta) is the default browser: Hyprland $browser, $BROWSER and the xdg
# mime defaults below all point at zen-beta.
{ features, lib, ... }:
let
  # mime -> desktop file for "Zen is the default browser".
  zenDesktopFile = "zen-beta.desktop";
  browserMimes = [
    "application/xhtml+xml"
    "application/json"
    "text/html"
    "text/plain"
    "x-scheme-handler/about"
    "x-scheme-handler/chrome"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/mailto"
    "x-scheme-handler/unknown"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xht"
    "application/x-extension-xhtml"
  ];
in
{
  imports = with features; [
    chrome
    firefox
  ];

  # Zen handles http(s) and local html everywhere xdg-open is used.
  xdg.mimeApps = {
    enable = true;
    associations.added = lib.genAttrs browserMimes (_: [ zenDesktopFile ]);
    defaultApplications = lib.genAttrs browserMimes (_: [ zenDesktopFile ]);
  };

  home.sessionVariables.BROWSER = "zen-beta";
}
