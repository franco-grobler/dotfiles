# Go: the toolchain settings, the server, and the binaries the editor shells
# out to.
{ config, pkgs, ... }:
{
  programs.go = {
    enable = true;
    env.GOPATH = "${config.xdg.configHome}/.go";
  };

  home.packages = with pkgs; [
    gopls
    gofumpt # fast-moving: 0.10.0 vs 0.12.0
    gotools # provides goimports
    golangci-lint

    # templ: the CLI is the generator, the formatter (`templ fmt`) and the
    # language server (`templ lsp`) -- see nvim/lua/plugins/lang/templ.lua.
    templ

    # The two code actions wired through none-ls in
    # nvim/lua/plugins/lang/go.lua -- add/remove struct tags, and generate
    # interface method stubs.
    gomodifytags
    impl

    # The debugger nvim-dap-go drives. Unlike the other debug adapters this
    # is a plain CLI resolved from PATH, so it belongs here rather than in
    # Mason -- its config is next door in dlv/, which until now was
    # configuring a binary nothing installed.
    delve
  ];
}
