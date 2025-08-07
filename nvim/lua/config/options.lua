-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local os = vim.loop.os_uname().sysname
local is_mac = os == "Darwin"

local opt = vim.opt

opt.wrap = true  -- Enable line wrap
opt.spell = true -- Enable spell checking
opt.mouse = ""

local g = vim.g

-- LazyVim
g.lazyvim_python_lsp = "mypy"

-- VimTex
if is_mac then
  g.vimtex_view_method = "skim"
else
  g.vimtex_view_method = "zathura"
end

-- File types
local ft = vim.filetype
ft.add({
  extension = {
    arb = "json",
  },
})
ft.add({
  filename = {
    ["atlas.hcl"] = "atlas-config",
  },
  pattern = {
    [".*/*.my.hcl"] = "atlas-schema-mysql",
    [".*/*.pg.hcl"] = "atlas-schema-postgresql",
    [".*/*.lt.hcl"] = "atlas-schema-sqlite",
    [".*/*.ch.hcl"] = "atlas-schema-clickhouse",
    [".*/*.ms.hcl"] = "atlas-schema-mssql",
    [".*/*.rs.hcl"] = "atlas-schema-redshift",
    [".*/*.test.hcl"] = "atlas-test",
    [".*/*.plan.hcl"] = "atlas-plan",
    [".*/*.rule.hcl"] = "atlas-rule",
  },
})

vim.treesitter.language.register("hcl", "atlas-config")
vim.treesitter.language.register("hcl", "atlas-schema-mysql")
vim.treesitter.language.register("hcl", "atlas-schema-postgresql")
vim.treesitter.language.register("hcl", "atlas-schema-sqlite")
vim.treesitter.language.register("hcl", "atlas-schema-clickhouse")
vim.treesitter.language.register("hcl", "atlas-schema-mssql")
vim.treesitter.language.register("hcl", "atlas-schema-redshift")
vim.treesitter.language.register("hcl", "atlas-test")
vim.treesitter.language.register("hcl", "atlas-plan")
vim.treesitter.language.register("hcl", "atlas-rule")

vim.lsp.enable("atlas")
