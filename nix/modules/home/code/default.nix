# Editor, language runtimes and the clients you reach for while coding.
{ features, ... }:
{
  imports = with features; [
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
