-- mini-files extra: <leader>fm opens a file explorer you navigate and edit
-- like a buffer -- renaming a line renames the file. <leader>fM opens it at
-- the cwd rather than the current file.
return {
  { import = "lazyvim.plugins.extras.editor.mini-files" },
}
