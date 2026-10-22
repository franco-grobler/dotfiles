-- templ (Go HTML templating, https://templ.guide). There is no LazyVim extra,
-- so the pieces are wired directly:
--
--   * `templ lsp` -- lspconfig's `templ` entry. It proxies gopls for the Go
--     expressions inside components, so go-to-definition, completion and
--     diagnostics work across .templ and .go files. The binary comes from nix
--     (modules/home/code/languages/go.nix).
--   * treesitter `templ` for highlighting; it injects go, html, css and js.
--   * `templ fmt` via conform.
--
-- Neovim already maps *.templ to the `templ` filetype, and tailwindcss's
-- lspconfig entry lists templ, so class completion works with no extra setup.
--
-- `templ generate` is still yours to run (or `templ generate --watch`); the
-- LSP does not write the *_templ.go files.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "templ" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = { mason = false },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        templ = { "templ" },
      },
    },
  },
}
