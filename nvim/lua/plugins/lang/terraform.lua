-- terraform extra: terraformls, treesitter terraform + hcl, tflint,
-- and a telescope picker for the registry.
return {
  { import = "lazyvim.plugins.extras.lang.terraform" },

  -- Format with OpenTofu rather than the terraform binary.
  --
  -- `tofu` is deliberately NOT installed globally: its version is part of a
  -- project's contract, since state written by one version is not always
  -- readable by another, and a global copy silently differing from CI is
  -- exactly the failure you do not want. Put it in the project's devShell
  -- (see nvim/lua/plugins/lang/sql.lua for the flake + .envrc shape) and
  -- launch nvim from inside that directory.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        tf = { "tfmt" },
        terraform = { "tfmt" },
        ["terraform-vars"] = { "tfmt" },
        hcl = { "tfmt" },
      },
      formatters = {
        tfmt = {
          command = "tofu",
          args = { "fmt", "-" },
          stdin = true,
        },
      },
    },
  },

  -- And validate with it too: the extra's `terraform_validate` linter
  -- hardcodes `terraform`. nvim-lint defines that linter as a function, so a
  -- table override would replace it outright (parser and all) -- wrap it
  -- instead and only swap the command.
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        terraform_validate = function()
          local linter = require("lint.linters.terraform_validate")()
          linter.cmd = "tofu"
          return linter
        end,
      },
    },
  },
}
