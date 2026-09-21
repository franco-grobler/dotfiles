# Markdown. markdownlint-cli2 runs as a linter and a formatter; markdown-toc
# keeps tables of contents in sync.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    marksman
    markdownlint-cli2
    markdown-toc
  ];
}
