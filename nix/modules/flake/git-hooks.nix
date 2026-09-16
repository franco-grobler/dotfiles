# Git hooks, installed by entering the dev shell rather than by remembering to.
#
# This replaces `just add-hooks` copying pre-push.sh by hand: the hooks are
# declared here, and `nix develop` (or direnv, via the repo's .envrc) writes
# .git/hooks on the way in. A machine that has never run the recipe is no
# longer a machine with no hooks.
#
# `nix flake check` gets a `pre-commit-check` derivation out of this too, so CI
# runs the same lints the hooks do without a second definition of them.
{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { config, ... }:
    {
      pre-commit = {
        # `rootSrc` is left at the flake root (nix/), which is as far as a
        # pure evaluation can see -- the repo root is outside the flake's
        # source. That scopes only the `pre-commit` *check* derivation; the
        # installed hooks find the real git root at run time and cover the
        # whole repo.
        settings = {
          hooks = {
            treefmt = {
              enable = true;
              packageOverrides.treefmt = config.formatter;
            };

            # Lints, not formatters -- they report rather than rewrite, so they
            # are hooks instead of treefmt entries. `statix fix` and
            # `deadnix --edit` are available by hand when you want the rewrite.
            statix.enable = true;
            deadnix = {
              enable = true;
              settings.noLambdaPatternNames = true;
            };
          };
        };
      };
    };
}
