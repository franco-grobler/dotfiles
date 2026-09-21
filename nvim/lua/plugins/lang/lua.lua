-- Lua is configured by LazyVim core (lua_ls + treesitter), so there is no
-- `lang.lua` extra. What lives here is the editing-Neovim-itself setup.
--
-- dap.nlua extra: one-small-step-for-vimkind, so <F5> can debug this config.
return {
  { import = "lazyvim.plugins.extras.dap.nlua" },

  -- Types and completion for the Neovim API (replaced neodev).
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
}
