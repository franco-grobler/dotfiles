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
-- LazyVim mostly copes with the absence by design: branches that would use
-- Mason are behind `LazyVim.has(...)`, and servers fall through to
-- `vim.lsp.enable(server)`, resolved from PATH. `mason = false` on individual
-- servers (c.lua, ansible.lua, atlas.lua, wasm.lua) is now redundant, but it
-- is still the right thing to write if Mason ever comes back.
--
-- The exception is `LazyVim.get_pkg_path`, which builds a path into Mason's
-- install directory unconditionally. The vue and astro extras use it for the
-- `location` of their tsserver plugin; tsserver silently skips a plugin it
-- cannot find, so vtsls parses .vue as plain TS. `nix_pkg_paths` below
-- answers those lookups from the nix store instead -- resolved from PATH at
-- runtime, so it follows package upgrades. Add an entry here when importing
-- another extra that calls get_pkg_path (svelte, angular).
--
-- What Mason was the only source of, and is no longer installed: codelldb,
-- debugpy, js-debug-adapter and dart-debug-adapter (so dap has no adapter for
-- rust/c, python, js/ts or dart), cmakelang and cmakelint, eslint_d, tflint,
-- and a global prettier. Add them to the nix side if you want them back --
-- astro.lua already expects prettier to come from the project, not globally.

-- /nix/store/<hash>-<name> of the package that puts `bin` on PATH.
local function store_path(bin)
  local exe = vim.fn.exepath(bin)
  return exe ~= "" and vim.fn.resolve(exe):match("^/nix/store/[^/]+") or nil
end

-- tsserver resolves a plugin by walking up from `location` looking for
-- node_modules/<name>. When a package ships the plugin somewhere else, link
-- it into a directory under the cache that has that layout.
local function node_modules_shim(name, dir)
  local root = vim.fn.stdpath("cache")
    .. "/nix-tsserver-plugins/"
    .. name:gsub("/", "+")
  local link = root .. "/node_modules/" .. name
  if vim.uv.fs_readlink(link) ~= dir then
    vim.fn.mkdir(vim.fs.dirname(link), "p")
    vim.uv.fs_unlink(link)
    vim.uv.fs_symlink(dir, link)
  end
  return root
end

-- Mason package name -> function returning the nix equivalent of the path
-- the extra asked for, or nil to fall back to LazyVim's own lookup.
local nix_pkg_paths = {
  -- Mason's <pkg>/node_modules/@vue/language-server; @vue/typescript-plugin
  -- is in its node_modules.
  ["vue-language-server"] = function()
    local store = store_path("vue-language-server")
    return store and store .. "/lib/language-tools/packages/language-server"
  end,
  -- The plugin is in the package, but not under any node_modules/@astrojs.
  ["astro-language-server"] = function()
    local store = store_path("astro-ls")
    return store
      and node_modules_shim(
        "@astrojs/ts-plugin",
        store
          .. "/lib/node_modules/astro-language-server/packages/language-tools/ts-plugin"
      )
  end,
}

local get_pkg_path = LazyVim.get_pkg_path
---@diagnostic disable-next-line: duplicate-set-field
LazyVim.get_pkg_path = function(pkg, path, opts)
  local nix = nix_pkg_paths[pkg]
  return nix and nix() or get_pkg_path(pkg, path, opts)
end

return {
  { import = "lazyvim.plugins.extras.lsp.neoconf" },

  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
