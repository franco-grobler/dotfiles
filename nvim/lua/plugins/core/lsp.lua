-- Cross-language LSP plumbing. Per-server config lives in the file for that
-- language; only things that apply to every server belong here.
--
-- neoconf extra: project-local settings via .neoconf.json (you have one at
-- the root of this repo).
--
-- Mason is off, all three plugins. Every tool this config needs already comes
-- from nix (nix/modules/home/code/), and Mason prepends its own bin directory
-- to PATH, so where both had a copy Mason's won -- 44 of the 59 binaries it
-- had installed were duplicates, and the ruff that languages/python.nix pins
-- deliberately was not the ruff nvim was running. One provider, declared in
-- one place, is the whole point of installing them from nix.
--
-- LazyVim copes with the absence by design: every branch that would use Mason
-- is behind `LazyVim.has(...)`, and servers fall through to
-- `vim.lsp.enable(server)`, resolved from PATH. `mason = false` on individual
-- servers (c.lua, ansible.lua, atlas.lua, wasm.lua) is now redundant, but it
-- is still the right thing to write if Mason ever comes back.
--
-- What Mason was the only source of, and is no longer installed: codelldb,
-- debugpy, js-debug-adapter and dart-debug-adapter (so dap has no adapter for
-- rust/c, python, js/ts or dart), cmakelang and cmakelint, eslint_d, tflint,
-- and a global prettier. Add them to the nix side if you want them back --
-- astro.lua already expects prettier to come from the project, not globally.
return {
  { import = "lazyvim.plugins.extras.lsp.neoconf" },

  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
