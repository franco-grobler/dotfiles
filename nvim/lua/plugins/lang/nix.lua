-- nix extra: nil_ls, treesitter nix, nixfmt via conform.
-- Your own toolchain (nixfmt, statix) is installed in
-- nix/modules/home/code/languages.nix.
return {
  { import = "lazyvim.plugins.extras.lang.nix" },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        -- Matches `nix fmt`, in nix/modules/flake/formatter.nix.
        nixfmt = { prepend_args = { "--width=80" } },
      },
    },
  },
}
