local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Extras are imported from the per-language files in lua/plugins/ rather than
-- listed in lazyvim.json, so that everything about a language lives in one
-- file. That puts the extra imports after `plugins` in the module order, which
-- LazyVim warns about; the warning is the only consequence. Within each file
-- the `import` line comes first, so our overrides still merge last.
vim.g.lazyvim_check_order = false

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Our own plugins, grouped. lazy.nvim's `lsmod` does not recurse into
    -- subdirectories on its own, but importing one by name does load every
    -- file inside it -- so a new language only means a new file in lang/,
    -- while adding a whole group is one line here.
    { import = "plugins.core" }, -- lsp, formatting, debugging, testing
    { import = "plugins.lang" }, -- one file per language
    { import = "plugins.editor" }, -- editing behaviour, language-agnostic
    { import = "plugins.ui" }, -- layout and appearance
    { import = "plugins.tools" }, -- everything else
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = true, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
