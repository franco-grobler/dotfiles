-- astro extra: astro-language-server, treesitter astro + css.
--
-- Formatting is the one gap. oxfmt cannot parse .astro -- not a version
-- problem, it is unimplemented as of 0.68:
--   https://github.com/oxc-project/oxc/issues/19715  (Svelte done, Astro not)
--
-- A global prettier cannot do it either: the parser lives in
-- prettier-plugin-astro, which prettier v3 only loads when a project declares
-- it. The astro language server bundles volar-service-prettier but not that
-- plugin, so LSP formatting has the same dependency.
--
-- conform resolves prettier from the project first (`util.from_node_modules`),
-- so this works in any Astro project set up the way the Astro docs prescribe:
--
--     package.json  devDependencies: prettier, prettier-plugin-astro
--     .prettierrc   { "plugins": ["prettier-plugin-astro"] }
--
-- Verified: with both present, formatting works; with the plugin missing,
-- prettier reports "No parser could be inferred" and the buffer is left alone.
--
-- When oxc ships astro support it will not switch over on its own -- per that
-- issue you have to install @astrojs/compiler-rs and set `astro: true` in
-- .oxfmtrc.json. At that point delete this conform block and drop `astro`
-- from `cannot_parse` in formatting.lua.
return {
  { import = "lazyvim.plugins.extras.lang.astro" },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        astro = { "prettier" },
      },
    },
  },
}
