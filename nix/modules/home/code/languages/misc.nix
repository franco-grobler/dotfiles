# The odds and ends: languages whose entire toolchain is one package, and a
# few things that are not tied to a language at all. Anything here graduates
# to its own file as soon as it needs a second package.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust. rustup manages the rest of the toolchain itself, rust-analyzer
    # included, so there is nothing else to install.
    rustup

    # Typst. tinymist formats as well as serves, so typstyle is not needed --
    # but it is worth watching more than the version gap suggests, because it
    # changes its settings schema between releases and
    # nvim/lua/plugins/lang/typst.lua passes those settings straight through.
    tinymist # fast-moving: 0.14.18 vs 0.15.8

    # Terraform. tflint is not here because nothing invokes it -- nvim-lint
    # runs `terraform validate` instead -- and tofu, which does the
    # formatting, is per-project and lives in that project's devShell.
    terraform-ls

    # CMake, server only. Nothing formats cmake, and nvim-lint's linter wants
    # a binary called `cmakelint`, which is a different tool from cmakelang's
    # `cmake-lint` and has no nixpkgs package -- so that one linter is the
    # last thing here still coming from Mason.
    neocmakelsp

    # Servers whose language needs nothing else.
    prisma-language-server
    helm-ls
    taplo # TOML
    yaml-language-server # fast-moving: 1.23.0 vs 1.24.0

    # Spell checking in every filetype. The editor talks to typos-lsp, which
    # bundles its own copy of the engine; the CLI is for shells and hooks.
    typos-lsp # fast-moving: 0.1.51 vs 0.1.56
    typos # fast-moving: 1.46.3 vs 1.50.2

    # Building treesitter parsers that ship no prebuilt grammar.
    tree-sitter
  ];
}
