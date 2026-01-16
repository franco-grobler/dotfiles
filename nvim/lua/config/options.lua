-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local os = vim.loop.os_uname().sysname
local is_mac = os == "Darwin"

local opt = vim.opt

opt.wrap = true  -- Enable line wrap
opt.spell = true -- Enable spell checking
opt.spelllang = { "en_gb" }
opt.mouse = ""

local g = vim.g

-- g.lazyvim_python_lsp = "basedpyright"
g.lazyvim_python_lsp = "ty"

-- VimTex
if is_mac then
  g.vimtex_view_method = "skim"
else
  g.vimtex_view_method = "zathura"
end

-- File types
local filetype = vim.filetype
filetype.add({
  extension = {
    arb = "json",
  },
})
filetype.add({
  extension = {
    pipeline = "groovy",
  },
})
