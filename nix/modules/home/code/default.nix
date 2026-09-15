# Editor, language runtimes and the clients you reach for while coding.
{ features, ... }:
{
  imports = with features; [
    atlas
    neovim
    languages
    go
    pnpm
    prettierd
    dlv
    octave
    posting
    lazysql
  ];
}
