-- typos-lsp: a low-false-positive source spell checker. There is no LazyVim
-- extra for it, so the server is enabled here directly.
--
-- Its upstream root_markers are typos.toml / _typos.toml / .typos.toml /
-- Cargo.toml / pyproject.toml, which means it only attaches in projects that
-- happen to have one of those. Falling back to the git root makes it run
-- everywhere, which is the point of a spell checker.
--
-- Per-project rules still work the usual way: drop a typos.toml at the root
-- and typos-lsp picks it up.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {
          root_dir = function(bufnr, on_dir)
            local markers =
              { "typos.toml", "_typos.toml", ".typos.toml", ".git" }
            on_dir(vim.fs.root(bufnr, markers) or vim.fn.getcwd())
          end,
        },
      },
    },
  },
}
