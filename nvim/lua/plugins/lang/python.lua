-- python extra: ruff (lint + format) and basedpyright/pyright, treesitter
-- ninja + rst, neotest-python, and nvim-dap-python for debugging.
return {
  { import = "lazyvim.plugins.extras.lang.python" },

  -- `ty` is Astral's type checker, selected via g.lazyvim_python_lsp in
  -- lua/config/options.lua -- the extra reads that to decide which of
  -- pyright / basedpyright / ty to enable and disables the rest.

  -- mypy as a linter, which is what it is -- it has no language server.
  -- It runs on save and needs the project's interpreter, so pick the venv
  -- with <leader>cvs first in a project that has one.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "mypy" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "mypy" } },
  },

  -- Pick the interpreter for the current project. The python extra already
  -- pulls venv-selector in; this is just the keymaps and eager load.
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    opts = {},
    event = "VeryLazy",
    keys = {
      { "<leader>cvs", "<cmd>VenvSelect<cr>", desc = "VenvSelector" },
      {
        "<leader>cvc",
        "<cmd>VenvSelectCached<cr>",
        desc = "VenvSelector (cached)",
      },
    },
  },
}
