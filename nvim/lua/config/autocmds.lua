-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatically commit lockfile after running Lazy Update (or Sync)
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyUpdate",
  callback = function()
    local home = vim.env.HOME
    local repo_dir = home .. "/dotfiles"
    local lockfile = repo_dir .. "/nvim/lazy-lock.json"

    local cmd = {
      "git",
      "-C",
      repo_dir,
      "add-and-commit",
      lockfile,
      "chore(nvim): update lazynvim lockfile",
    }

    local success, process = pcall(function()
      return vim.system(cmd):wait()
    end)

    if process and process.code == 0 then
      vim.notify("Committed lazy-lock.json: " .. process.stdout)
    else
      if not success then
        vim.notify(
          "Failed to run command '"
            .. table.concat(cmd, " ")
            .. "':"
            .. tostring(process),
          vim.log.levels.ERROR,
          {}
        )
      else
        vim.notify(
          "git ran but failed to commit: " .. process.stdout,
          vim.log.levels.WARN,
          {}
        )
      end
    end
  end,
})
