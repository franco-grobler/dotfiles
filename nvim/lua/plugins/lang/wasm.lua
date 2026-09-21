-- WebAssembly text format. There is no LazyVim extra, so the server is
-- configured directly -- wasm-language-tools ships an lspconfig entry
-- (wasm_language_tools) covering .wat / .wast.
--
-- Used rarely, so it is not installed globally:
--
--     packages = [ pkgs.wasm-language-tools ];
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        wasm_language_tools = { mason = false },
      },
    },
  },
}
