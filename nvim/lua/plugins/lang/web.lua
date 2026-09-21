-- HTML and CSS have no LazyVim extra -- the servers come from
-- vscode-langservers-extracted and just need to be installed.
--
-- tailwind extra: tailwindcss-language-server plus colour swatches in
-- completion for class names.
return {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
}
