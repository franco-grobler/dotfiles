return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap-python",
  },
  opts = {
    name = { "venv", ".venv" }
  },
  event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { "<leader>cvs", "<cmd>VenvSelect<cr>",       desc = "Select virtual environment" },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { "<leader>cvc", "<cmd>VenvSelectCached<cr>", desc = "Use cached virtual environment" },
  },
}
