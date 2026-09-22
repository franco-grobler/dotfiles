# The nix lints, as a `nix flake check` output.
#
# git-hooks.nix used to contribute a `pre-commit-check` derivation, so CI got
# statix and deadnix for free alongside the hooks. prek runs the hooks but
# builds nothing, so the same two lints are a check of their own here -- CI
# gates on them without having to install a hook or run prek.
#
# Scoped to `nix/`, which is as far as a pure evaluation can see: the repo root
# is outside the flake's source. The installed hook covers the whole repo,
# because it runs against the real git root. Formatting is not checked here --
# CI runs `nix fmt -- --ci` for that, over the whole repo rather than this
# subset.
{
  perSystem =
    { pkgs, ... }:
    {
      checks.lints = pkgs.runCommand "nix-lints" { } ''
        cd ${../..}
        ${pkgs.statix}/bin/statix check
        ${pkgs.deadnix}/bin/deadnix --no-lambda-pattern-names --fail
        touch $out
      '';
    };
}
