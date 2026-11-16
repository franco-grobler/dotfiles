# The web stack: TypeScript and JavaScript, the markup and styling servers
# that come with them, and the framework servers on top.
#
# One file rather than a typescript/web split, because the oxc tools at the
# bottom lint and format all of it -- ts, js, json, css, html and markdown
# alike -- so splitting only puts the toolchain in a different file from the
# languages it serves.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs

    # TypeScript. 0.3.0, matching upstream exactly.
    #
    # nixpkgs pins vtsls to nodejs-slim_22, which Hydra doesn't cache on
    # darwin -- so every lockfile bump meant compiling V8 from source. The
    # default nodejs-slim is cached and runs vtsls just as well.
    (vtsls.override { nodejs-slim_22 = nodejs-slim; })

    # html, cssls, jsonls and eslint -- four servers in one derivation.
    vscode-langservers-extracted

    tailwindcss-language-server # fast-moving: 0.14.29 vs 0.16.0
    vue-language-server # fast-moving: 3.2.9 vs 3.3.11
    astro-language-server

    # The oxc toolchain: oxlint replaces eslint's linting, oxfmt replaces
    # prettier everywhere except .astro (oxc-project/oxc#19715, which is why
    # nvim/lua/plugins/lang/astro.lua still reaches for a project-local
    # prettier).
    #
    # oxc ships weekly and nixpkgs trails it further than anything else in
    # this config -- check these two first when a bug looks like one that was
    # already fixed upstream.
    oxlint # fast-moving: 1.65.0 vs 1.85.0 -- twenty minors
    oxfmt # fast-moving: 0.45.0 vs 0.70.0 -- the widest gap here
  ];
}
