return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = { "dart" },
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
  },
  -- Update dependencies --
  {
    "akinsho/pubspec-assist.nvim",
    ft = { "dart" },
    lazy = true,
    dependencies = { "plenary.nvim" },
    config = function()
      require("pubspec-assist").setup({})
    end,
  },
}
