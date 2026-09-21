-- dap.core extra: nvim-dap, nvim-dap-ui, virtual text, and launch.json
-- support. Adapters come from the lang extras (go, python, typescript);
-- the Lua adapter is in lua.lua.
--
-- LazyVim binds stepping to <leader>di / <leader>do / <leader>dO -- three
-- keystrokes per step, with `o` vs `O` deciding out vs over. Unusable while
-- you're actually walking through a program.
--
-- These are the F-keys every other debugger uses (VS Code, IntelliJ, GDB
-- frontends). The <leader>d maps stay as aliases; only the keys you press in
-- a tight loop move to single presses.
return {
  { import = "lazyvim.plugins.extras.dap.core" },

  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<F5>",  function() require("dap").continue() end,          desc = "Debug: Continue" },
      { "<F17>", function() require("dap").terminate() end,         desc = "Debug: Terminate" },  -- shift+F5
      { "<F9>",  function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F23>", function() require("dap").step_out() end,          desc = "Debug: Step Out" },   -- shift+F11
    },
  },
}
