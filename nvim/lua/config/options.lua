-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.wrap = true  -- Enable line wrap
opt.spell = true -- Enable spell checking
opt.mouse = ""

local g = vim.g

g.lazyvim_python_lsp = "basedpyright"

-- VimTex
g.vimtex_view_method = "skim"

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
