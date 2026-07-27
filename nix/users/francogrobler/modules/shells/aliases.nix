{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  home.shellAliases = {
    cl = "clear";
    ".." = "cd ..";
    "..." = "cd ../..";
    justg = "just --global-justfile";
    l = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    ltree = "eza --tree --level=2  --icons --git";
    "gemini-cli" = "GEMINI_API_KEY=$(op read $GEMINI_API_KEY) gemini";
  }
  // (
    if isLinux then
      {
        pbcopy = "xclip";
        pbpaste = "xclip -o";
      }
    else if isDarwin then
      {
        drawio = "$HOME/Applications/draw.io.app/Contents/MacOS/draw.io";
      }
    else
      { }
  );
}
