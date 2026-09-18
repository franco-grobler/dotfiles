# `nix develop` -- and, through .envrc, just being in the repo.
#
# Entering it installs the git hooks (see git-hooks.nix) and puts the tools the
# repo's own tasks need on PATH, so a fresh clone needs no setup step beyond
# `direnv allow`.
{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        inherit (config.pre-commit.devShell) shellHook;

        packages = with pkgs; [
          just

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
        ];
      };
    };
}
