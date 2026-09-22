# `nix develop` -- and, through .envrc, just being in the repo.
#
# Entering it installs the git hooks and puts the tools the repo's own tasks
# need on PATH, so a fresh clone needs no setup step beyond `direnv allow`.
#
# Every hook in .pre-commit-config.yaml is a bare command name resolved from
# this list, so a tool a hook needs belongs here and nowhere else. That is why
# `config.formatter` is on it: the treefmt hook has to be the same treefmt
# `nix fmt` runs, not whichever one happens to be around.
{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        shellHook = ''
          prek install --overwrite >/dev/null
        '';

        packages = [
          # `nix fmt`, by the name the treefmt hook calls it.
          config.formatter
        ]
        ++ (with pkgs; [
          just

          # Runs .pre-commit-config.yaml. A drop-in pre-commit written in
          # Rust -- nixpkgs' `pre-commit` needs dotnet-sdk, which is built
          # from the dotnet source tarball and regularly fails outright.
          prek

          # The same lints the hooks and CI run, for running by hand --
          # `statix fix` and `deadnix --edit` rewrite what they find.
          nixfmt
          statix
          deadnix

          # Reading what a build or a closure actually did.
          nix-output-monitor
          nix-tree
          nvd

          # Nix language server, so the 100-odd modules in this tree get
          # completion and go-to-definition on nixos/darwin/home-manager
          # options instead of being edited blind.
          nixd

          # Editor tooling that is deliberately NOT in home.packages, because
          # its behaviour is per-project: sqruff reads the repo's dialect from
          # .sqruff, and tofu has to match the version the state was written
          # with. Neovim picks both up from PATH, so they work in any project
          # whose shell provides them -- see nvim/lua/plugins/lang/sql.lua.
          #
          # Nothing in this repo is .sql or .tf; these are here as the
          # reference copy of the pattern. Drop them if that bothers you.
          sqruff
          opentofu
        ]);
      };
    };
}
