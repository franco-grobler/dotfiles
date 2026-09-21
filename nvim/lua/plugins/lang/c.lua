-- clangd extra: clangd LSP with the usual switch-source-header keymap,
-- treesitter c/cpp, clang-format via conform, and codelldb for debugging.
--
-- Used rarely, so clangd and clang-format are not installed globally --
-- `mason = false` configures and enables the server but resolves it from
-- PATH. One nixpkgs package covers both:
--
--     packages = [ pkgs.clang-tools ];   # clangd + clang-format
--
-- codelldb still comes from Mason, because the rust setup wants it anyway.
return {
  { import = "lazyvim.plugins.extras.lang.clangd" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = { mason = false },
      },
    },
  },
}
