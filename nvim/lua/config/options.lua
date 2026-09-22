-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.colorcolumn = "80"
opt.mouse = ""
opt.spell = true
opt.wrap = true

local g = vim.g

-- Which server the LazyVim python extra enables. It has to name a real
-- language server: this once said `mypy`, which lspconfig has no entry for,
-- and python was left with no LSP at all, silently. `ty` is Astral's type
-- checker and is a real server, so it covers what mypy was here for -- see
-- lua/plugins/lang/python.lua.
g.lazyvim_python_lsp = "ty"

-- Preview compiled PDFs in Skim.
g.vimtex_view_method = "skim"
