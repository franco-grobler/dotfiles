# `nix fmt`, and the shell you get from `nix develop`.
#
# The nixfmt width is set on the formatter itself, not in a treefmt.toml:
# `pkgs.nixfmt-tree` bakes its own treefmt config into the wrapper and never
# reads one from the tree, so a treefmt.toml or .nixfmt.toml sitting next to
# the sources looks authoritative and does nothing.
#
# treefmt takes its tree root from the enclosing git repo, not from the flake
# directory, so `nix fmt` run in nix/ still covers the whole dotfiles repo --
# the shell scripts, the neovim lua and the workflow included.
#
# What is deliberately *not* formatted: the program config files under
# modules/home/**. Those are vendored upstream defaults kept with their
# original comments, so reformatting them would churn the diff and lose the
# upstream shape that makes them easy to re-sync.
{
  perSystem =
    { pkgs, inputs', ... }:
    let
      # perSystem's `pkgs` is plain nixpkgs -- the cherry-pick overlay in
      # channels.nix only reaches host configurations, not the flake's own
      # outputs -- so the unstable panache is reached directly here. See
      # modules/home/code/languages/markdown/default.nix for why it has to be
      # the unstable one.
      panache = inputs'.nixpkgs-unstable.legacyPackages.panache;
    in
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs =
          (with pkgs; [
            nixfmt
            shfmt
            stylua
            taplo

            # Below this line: the external formatters panache hands
            # fenced code blocks to (oxfmt above does both). The list has
            # to track [formatters] in
            # modules/home/code/languages/markdown/config.toml: a tool
            # missing here is not an error, it is a code block that quietly
            # stays unformatted in `nix fmt` while the editor formats it.
            # nixfmt, shfmt, stylua and taplo above are shared with both
            # jobs.
            ruff
            gofumpt
            gotools # goimports, piped into gofumpt for go blocks
            rustfmt
            tex-fmt
            oxfmt
          ])
          ++ [ panache ]; # not pkgs.panache -- see above

        settings = {
          on-unmatched = "info";

          # Generated or vendored: owned by a tool, not by hand.
          global.excludes = [
            "CHANGELOG.md" # git-cliff
            "nvim/lazy-lock.json" # lazy.nvim
            "nvim/lazyvim.json" # LazyVim
            "nvim/spell/*"
            # Both spellings: `nix fmt` runs from the repo root, the
            # pre-commit check runs from the flake root (nix/).
            "nix/modules/home/**" # vendored program configs -- see above
            "modules/home/**"
            "*.lock"
            ".git/**"
          ];

          formatter = {
            nixfmt = {
              command = "nixfmt";
              options = [ "--width=80" ];
              includes = [ "*.nix" ];
            };

            shfmt = {
              command = "shfmt";
              options = [
                "--write"
                "--simplify"
                "--indent=2"
                "--case-indent"
              ];
              includes = [
                "*.sh"
                "*.bash"
              ];
            };

            stylua = {
              command = "stylua";
              # Picks up stylua.toml at the repo root on its own.
              options = [ "--respect-ignores" ];
              includes = [ "*.lua" ];
            };

            # oxfmt, not prettier -- see nvim/lua/plugins/core/formatting.lua.
            # prettier used to hold these three, which meant `nix fmt`
            # formatted a .yml with prettier while the editor formatted it
            # with oxfmt: two formatters, one file type. oxfmt is
            # prettier-compatible and produces byte-identical output on every
            # yaml and json file in this tree, so the swap costs nothing.
            # (It does not save the node dependency -- nixpkgs' oxfmt is an
            # npm wrapper and brings nodejs-slim in by itself.)
            #
            # .md is panache's (below), and .astro is nobody's here: oxfmt
            # cannot parse it and the parser is project-local, which is why
            # nvim/lua/plugins/lang/astro.lua resolves prettier from the
            # project rather than from this list.
            oxfmt = {
              command = "oxfmt";
              options = [ "--write" ];
              includes = [
                "*.yaml"
                "*.yml"
                "*.json"
              ];
            };

            # Markdown, with the same config the editor's panache reads --
            # passed explicitly because the pre-commit check runs sandboxed,
            # where the copy home-manager puts in ~/.config does not exist.
            panache = {
              command = "panache";
              options = [
                "--config"
                "${../home/code/languages/markdown/config.toml}"
                "format"
              ];
              includes = [ "*.md" ];
            };

            taplo = {
              command = "taplo";
              options = [
                "format"
                "--"
              ];
              includes = [ "*.toml" ];
            };
          };
        };
      };
    };
}
