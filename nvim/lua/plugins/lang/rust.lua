-- rust extra: rustaceanvim (rust-analyzer, not via lspconfig), crates.nvim
-- for Cargo.toml, treesitter rust + ron, neotest, and bacon_ls.
-- The toolchain comes from nix (rustup in modules/home/code/languages.nix).
return {
  { import = "lazyvim.plugins.extras.lang.rust" },
}
