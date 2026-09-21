-- Atlas: database schema-as-code. The CLI is installed from nix
-- (nix/modules/home/code/atlas.nix) and carries its own language server
-- (`atlas tool lsp --stdio`), so there is nothing for Mason to install.
--
-- Atlas files are HCL, but the server decides which dialect it is looking at
-- from the filetype -- so every *.<suffix>.hcl needs its own filetype, and
-- every one of those then needs pointing back at the hcl parser to get any
-- highlighting. lspconfig's docs spell all of that out as twenty-odd
-- literal lines; one table generates it.
local by_suffix = {
  my = "atlas-schema-mysql",
  pg = "atlas-schema-postgresql",
  lt = "atlas-schema-sqlite",
  ch = "atlas-schema-clickhouse",
  ms = "atlas-schema-mssql",
  rs = "atlas-schema-redshift",
  test = "atlas-test",
  plan = "atlas-plan",
  rule = "atlas-rule",
}

local pattern = {}
for suffix, ft in pairs(by_suffix) do
  pattern[".*/*." .. suffix .. ".hcl"] = ft
  vim.treesitter.language.register("hcl", ft)
end

-- The project config is matched by name rather than by suffix.
vim.treesitter.language.register("hcl", "atlas-config")

vim.filetype.add({
  filename = { ["atlas.hcl"] = "atlas-config" },
  pattern = pattern,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        atlas = { mason = false },
      },
    },
  },
}
