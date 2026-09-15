# Aliases that are not owned by a single tool. Tool-specific ones live with
# their tool (see just.nix).
{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  home.shellAliases = {
    cl = "clear";
    ".." = "cd ..";
    "..." = "cd ../..";
    l = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    ltree = "eza --tree --level=2  --icons --git";
  }
  // (
    if isLinux then
      {
        # Wayland; wl-clipboard comes with the desktop group.
        pbcopy = "wl-copy";
        pbpaste = "wl-paste";
      }
    else if isDarwin then
      {
        drawio = "$HOME/Applications/draw.io.app/Contents/MacOS/draw.io";
      }
    else
      { }
  );
}
