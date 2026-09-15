# `nix fmt`, and the shell you get from `nix develop`.
#
# The nixfmt width is set on the formatter itself, not in a treefmt.toml:
# `pkgs.nixfmt-tree` bakes its own treefmt config into the wrapper and never
# reads one from the tree, so a treefmt.toml or .nixfmt.toml sitting next to
# the sources looks authoritative and does nothing.
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = [ pkgs.nixfmt-rfc-style ];
        settings = {
          on-unmatched = "info";
          formatter.nixfmt = {
            command = "nixfmt";
            options = [ "--width=80" ];
            includes = [ "*.nix" ];
          };
        };
      };

      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          just
          nixfmt-rfc-style
          statix
        ];
      };
    };
}
