-- tex extra: texlab LSP and vimtex (<leader>l... for compile/view/clean).
return {
  { import = "lazyvim.plugins.extras.lang.tex" },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        tex = { "tex-fmt" },
      },
    },
  },
}
