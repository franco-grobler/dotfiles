# Per-language toolchains: the runtime, its language server, and whatever
# formatters and linters go with it -- one file per language.
#
# A language earns a file once it needs more than one package. Everything
# that is the only thing its language needs lives in misc.nix, so this
# directory does not fill up with one-line files.
#
# Tooling that is per-project rather than per-machine is deliberately absent:
# ansible, clang-tools, wasm-language-tools, sqruff and tofu all go in the
# devShell of the project that needs them, each documented in the matching
# file under nvim/lua/plugins/lang/.
{ features, ... }:
{
  imports = with features; [
    dlv
    docker
    go
    lua
    markdown
    misc
    nix
    python
    sh
    tex
    web
  ];
}
