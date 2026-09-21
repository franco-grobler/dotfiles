-- Ansible. Used rarely, so nothing is installed globally: `mason = false`
-- tells LazyVim to configure and enable the server but resolve it from PATH
-- (lsp/init.lua:257-267). Put it in the project's devShell:
--
--     packages = [ pkgs.ansible-language-server pkgs.ansible-lint ];
--
-- ansible-language-server shells out to ansible-lint itself, so both belong
-- in the shell. Launch nvim from inside the project -- see sql.lua for why.
--
-- NOT importing `lazyvim.plugins.extras.lang.ansible`: it hardcodes
-- ansible-lint into mason.nvim's ensure_installed, which `mason = false`
-- does not cover. The extra is three specs; they are reproduced here so the
-- install stays under our control.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = { mason = false },
      },
    },
  },
  {
    "mfussenegger/nvim-ansible",
    ft = { "yaml" },
    keys = {
      {
        "<leader>ta",
        function()
          require("ansible").run()
        end,
        ft = "yaml.ansible",
        desc = "Ansible Run Playbook/Role",
        silent = true,
      },
    },
  },
}
