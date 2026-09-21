-- typescript extra: vtsls, nvim-dap + js-debug-adapter, mini.icons.
-- oxc extra:        oxlint LSP (only attaches where an .oxlintrc exists)
--                   and oxfmt appended to conform for js/ts/json/vue/astro.
-- eslint extra:     eslint LSP with workingDirectories=auto, registered as a
--                   formatter at priority 200. This is what covers the repos
--                   oxlint won't attach to.
return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.typescript.oxc" },
  { import = "lazyvim.plugins.extras.linting.eslint" },
}
