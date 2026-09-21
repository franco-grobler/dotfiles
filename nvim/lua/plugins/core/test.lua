-- test.core extra: neotest. <leader>tr runs the nearest test, <leader>tt the
-- file, <leader>ts opens the summary panel. Adapters come from the lang
-- extras (go, python, rust all register one).
return {
  { import = "lazyvim.plugins.extras.test.core" },

  -- Coverage gutter signs: :Coverage to load, :CoverageToggle to show.
  {
    "andythigpen/nvim-coverage",
    version = "*",
    config = function()
      require("coverage").setup({
        auto_reload = true,
      })
    end,
  },
}
