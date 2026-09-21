-- The `lang.sql` extra was dropped: its headline feature is vim-dadbod-ui,
-- and lazysql (nix/modules/home/code/lazysql) covers that better.
--
-- sqruff is deliberately NOT installed globally. Its dialect -- postgres vs
-- mysql vs sparksql -- is per-project config in .sqruff, and a global copy
-- would lint every project as ANSI. Put it in the project's shell instead:
--
--     # flake.nix
--     devShells.default = pkgs.mkShellNoCC { packages = [ pkgs.sqruff ]; };
--
--     # .envrc
--     use flake
--
-- Neovim resolves formatters from its own PATH at spawn time, and direnv only
-- rewrites PATH at a shell prompt -- so launch nvim from inside the project
-- and this works. Launch it from ~ and conform will find nothing and leave
-- the buffer alone.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "sql" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqruff" },
      },
    },
  },
}
