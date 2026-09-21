-- markdown extra: marksman LSP, markdownlint-cli2, render-markdown.nvim
-- (in-buffer rendering) and markdown-preview.nvim (browser preview).
return {
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- The extra hardcodes prettier as the first formatter. Swap in oxfmt and
  -- keep the two markdown-specific tools after it. This has to live in the
  -- same file as the import above, so that it merges afterwards.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "oxfmt", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "oxfmt", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
}
