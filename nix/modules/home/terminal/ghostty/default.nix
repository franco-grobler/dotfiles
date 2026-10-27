# Ghostty itself comes from homebrew on darwin and nixpkgs on linux; only the
# configuration tree is shared. macos.config is linked and included on darwin
# only, so linux never sees the macos-* keys or the global keybind.
{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  xdg.configFile = {
    "ghostty/config".text =
      builtins.readFile ./config/config
      + lib.optionalString isDarwin ''
        config-file = "macos.config"
      '';
    "ghostty/keybindings.config".source = ./config/keybindings.config;
  }
  // lib.optionalAttrs isDarwin {
    "ghostty/macos.config".source = ./config/macos.config;
  };
}
