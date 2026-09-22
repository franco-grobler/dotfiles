-- markdown extra: panache (LSP + formatter + linter), render-markdown.nvim
-- (in-buffer rendering) and markdown-preview.nvim (browser preview).
--
-- panache replaces three of the extra's choices at once -- marksman as the
-- language server, prettier as the formatter, markdownlint-cli2 as the linter.
-- One Rust binary instead of three toolchains, and it parses pandoc/quarto
-- syntax (fenced divs, math, grid tables) that the others mangle. It comes
-- from nix: modules/home/code/languages/markdown/.
--
-- All of this has to live in the same file as the import below, so that it
-- merges afterwards.
return {
  { import = "lazyvim.plugins.extras.lang.markdown" },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- `panache format` reformats, then panache-fix (`panache lint --fix`)
        -- applies the auto-fixable rule violations on top -- the same split
        -- the extra had between prettier and markdownlint-cli2. markdown-toc
        -- has no panache equivalent, so it stays last.
        ["markdown"] = { "panache", "panache-fix", "markdown-toc" },

        -- .mdx keeps oxfmt. panache does not claim mdx -- it is not in the
        -- server's filetypes and not among the extensions it recognises -- and
        -- a pandoc-flavoured formatter has no reason to leave JSX and ESM
        -- imports alone. See core/formatting.lua for oxfmt.
        ["markdown.mdx"] = { "oxfmt", "markdown-toc" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "panache" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = { enabled = false },

        -- `mason = false` because nix already provides the binary -- the
        -- extra left marksman on Mason's default, so it was being installed
        -- twice.
        panache = { mason = false },
      },
    },
  },
}
