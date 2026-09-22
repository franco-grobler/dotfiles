-- go extra: gopls + goimports/gofumpt via conform, golangci-lint,
-- treesitter go/gomod/gosum/gowork, neotest-go, and nvim-dap + delve.
-- (delve itself comes from nix: modules/home/code/dlv.)
--
-- gomodifytags (add/remove struct tags) and impl (generate interface method
-- stubs) are code actions the go extra only registers through none-ls, in a
-- spec marked `optional = true` -- so dropping the none-ls extra silently
-- turned them off. none-ls is pulled back in here for those two tools.
--
-- Deliberately NOT importing `lazyvim.plugins.extras.lsp.none-ls`: that extra
-- registers none-ls as a formatter at priority 200, above conform, which
-- would make it the primary formatter for go, lua and sh. Requiring the
-- plugin without the extra leaves it as a code-action provider only.
return {
  { import = "lazyvim.plugins.extras.lang.go" },

  {
    "nvimtools/none-ls.nvim",
    -- The sources are listed here rather than inherited from the extras.
    --
    -- Several lang extras append none-ls sources from their own files behind
    -- `optional = true`, and whether such a block activates depends on
    -- whether none-ls was already in the spec when lazy.nvim reached it --
    -- which depends on directory scan order, since `lsmod` does not sort.
    -- Inheriting them means the source list changes depending on filenames.
    --
    -- Setting them explicitly also keeps out everything that would duplicate
    -- something else: the formatting sources (goimports, gofumpt,
    -- terraform_fmt) duplicate conform, and the diagnostic sources (hadolint,
    -- cmake_lint) duplicate nvim-lint, which would report each problem twice.
    config = function(_, opts)
      local nls = require("null-ls")
      opts.sources = {
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
      }
      nls.setup(opts)
    end,
  },
}
