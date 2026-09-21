-- Cross-language LSP plumbing. Per-server config lives in the file for that
-- language; only things that apply to every server belong here.
--
-- neoconf extra: project-local settings via .neoconf.json (you have one at
-- the root of this repo).
return {
  { import = "lazyvim.plugins.extras.lsp.neoconf" },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
}
