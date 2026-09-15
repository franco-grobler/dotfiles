# Ghostty itself comes from homebrew on darwin and nixpkgs on linux; only the
# configuration tree is shared.
{
  xdg.configFile."ghostty".source = ./config;
}
