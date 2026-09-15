{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;

      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          just
          nixfmt-rfc-style
          statix
        ];
      };
    };
}
