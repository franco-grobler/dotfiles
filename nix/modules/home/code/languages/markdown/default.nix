# Markdown. panache is the language server, the formatter and the linter in
# one binary; markdown-toc keeps tables of contents in sync.
#
# panache replaces marksman and markdownlint-cli2. marksman is F#, so it pulls
# in dotnet-sdk, which nixpkgs builds from the dotnet source tarball -- minutes
# of CPU on every bump, and it fails outright often enough (the same
# dotnet-stage0-vmr unpack that breaks pre-commit in this repo's own devShell)
# that a markdown language server is not worth paying for it. panache is Rust
# and substitutes from cache.
#
# It also replaces prettier/oxfmt for .md -- see modules/flake/formatter.nix
# and nvim/lua/plugins/lang/markdown.lua, which have to agree with this or the
# editor and `nix fmt` rewrite each other's output on every save.
#
# panache is on the unstable cherry-pick list: 26.05 carries 2.47, which
# escapes shortcut reference links (`[dendritic]` -> `\[dendritic\]`) when it
# formats GFM, and would mangle this repo's own READMEs.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    panache
    markdown-toc
  ];

  xdg.configFile."panache/config.toml".source = ./config.toml;
}
