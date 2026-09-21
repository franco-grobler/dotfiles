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
-- language server -- lspconfig has no `mypy`, and setting it to that left
-- python with no LSP at all, silently. mypy is a type checker and runs
-- through nvim-lint instead; see lua/plugins/lang/python.lua.
g.lazyvim_python_lsp = "ty"

-- Preview compiled PDFs in Skim.
g.vimtex_view_method = "skim"
