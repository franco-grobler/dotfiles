-- oxfmt is the formatter. The LazyVim prettier extra is not imported.
--
-- oxfmt is prettier-compatible and, as of 0.35, covers prettier's whole
-- surface: js/jsx/ts/tsx, json/jsonc, css/scss/less, html, md/mdx, yaml,
-- graphql and handlebars. It reads .prettierignore, and
-- `oxfmt --migrate=prettier` converts an existing .prettierrc.
--
-- The oxc extra (see typescript.lua) only registers oxfmt for the JS-side
-- filetypes, so the rest are registered here.
--
-- The one filetype oxfmt cannot parse but the oxc extra registers it for
-- anyway is astro -- see astro.lua. Rather than filtering that list
-- afterwards (which would depend on which plugin file lazy.nvim happens to
-- import first -- `lsmod` scans the directory unsorted) oxfmt is given a
-- condition, so it declines the buffer wherever it ends up listed.
--
-- oxfmt cannot parse .svelte either, but nothing here uses svelte, so it is
-- left alone; add it to `cannot_parse` if that changes.
local cannot_parse = { astro = true }

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "oxfmt" },
        scss = { "oxfmt" },
        less = { "oxfmt" },
        html = { "oxfmt" },
        yaml = { "oxfmt" },
        graphql = { "oxfmt" },
        handlebars = { "oxfmt" },
      },
      formatters = {
        oxfmt = {
          condition = function(_, ctx)
            return not cannot_parse[vim.bo[ctx.buf].filetype]
          end,
        },
      },
    },
  },
}
