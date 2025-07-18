-- lua/check_mason_lsps.lua (or paste directly into Neovim command line after `:lua `)

-- This script checks which Language Servers (LSPs) are currently installed by Mason.nvim.
-- It leverages Mason's internal registry to get the status of each LSP.

-- Ensure Mason is loaded. If it's not, this might throw an error or return nil.
-- It's best to run this after Neovim has fully started and Mason is active.
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")

if not mason_registry_ok then
  print("Error: mason-registry not found. Please ensure Mason.nvim is installed and loaded.")
  print("You might need to restart Neovim or run `:Mason` first.")
end

-- Get all packages registered with Mason
local all_packages = mason_registry.get_all_packages()

local found_lsps = {}

-- Iterate through all packages and check if they are installed LSPs
for _, pkg in pairs(all_packages) do
  -- Check if the package is an LSP and if it's currently installed
  if pkg:is_installed() then
    table.insert(found_lsps, pkg.name)
  end
end

-- Sort the list alphabetically for easier reading
table.sort(found_lsps)

for _, lsp_name in ipairs(found_lsps) do
  print(lsp_name)
end
