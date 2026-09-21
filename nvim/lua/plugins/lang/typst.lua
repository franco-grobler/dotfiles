-- typst extra: tinymist LSP, treesitter typst, typst-preview.nvim,
-- ts-comments, and typstyle via conform.
--
-- The typstyle *binary* is not needed and is not installed anywhere: the
-- extra sets `lsp_format = "prefer"` for typst, and tinymist formats with
-- typstyle internally (see formatterMode below). Verified -- typst files
-- format correctly with no typstyle on PATH.
return {
  { import = "lazyvim.plugins.extras.lang.typst" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          keys = {
            {
              "<leader>cP",
              function()
                local buf_name = vim.api.nvim_buf_get_name(0)
                local file_name = vim.fn.fnamemodify(buf_name, ":t")
                LazyVim.lsp.execute({
                  title = "Pin Main",
                  filter = "tinymist",
                  command = "tinymist.pinMain",
                  arguments = { buf_name },
                })
                LazyVim.info("Tinymist: Pinned " .. file_name)
              end,
              desc = "Pin main file",
            },
          },
          single_file_support = true, -- Fixes LSP attachment in non-Git dirs
          settings = {
            formatterMode = "typstyle",
            formatterProseWrap = true, -- wrap lines in content mode
            formatterPrintWidth = 80, -- limit line length to 80 if possible
            formatterIndentSize = 4, -- indentation width
          },
        },
      },
    },
  },
}
