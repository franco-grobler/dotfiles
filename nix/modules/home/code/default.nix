# Editor, language runtimes and the clients you reach for while coding.
{ features, ... }:
{
  imports = with features; [
    atlas
    neovim
    languages
    pnpm
    octave
    posting
    lazysql
  ];
}
