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
    { pkgs, ... }:
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = with pkgs; [
          nixfmt
          shfmt
          stylua
          prettier
          taplo
        ];

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
              # Picks up nvim/stylua.toml on its own.
              options = [ "--respect-ignores" ];
              includes = [ "*.lua" ];
            };

            prettier = {
              command = "prettier";
              options = [
                "--write"
                "--prose-wrap=preserve"
              ];
              includes = [
                "*.md"
                "*.yaml"
                "*.yml"
                "*.json"
              ];
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
