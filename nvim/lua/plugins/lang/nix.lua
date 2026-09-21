-- nix extra: nil_ls, treesitter nix, nixpkgs-fmt via conform.
-- Your own toolchain (nixfmt, statix) is installed in
-- nix/modules/home/code/languages.nix.
return {
  { import = "lazyvim.plugins.extras.lang.nix" },
}
