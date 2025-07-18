return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Use mason for these. Make sure these are listed in the nix-ld libraries when using NixOs.
      local ensure_installed = {}
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and not ensure_installed[server] then
          server_opts.mason = false
        end
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },
}
