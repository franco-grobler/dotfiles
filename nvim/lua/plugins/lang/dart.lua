-- No LazyVim extra for Dart; flutter-tools drives the dartls setup itself.

-- .arb is Flutter's localization format -- JSON with a defined schema, but
-- an extension nothing recognises on its own.
vim.filetype.add({ extension = { arb = "json" } })

return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = { "dart" },
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
  },
  -- Cargo-style dependency management for pubspec.yaml.
  {
    "akinsho/pubspec-assist.nvim",
    ft = { "dart" },
    dependencies = { "plenary.nvim" },
    config = function()
      require("pubspec-assist").setup({})
    end,
  },
}
