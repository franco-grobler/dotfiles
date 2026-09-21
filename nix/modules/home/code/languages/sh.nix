# Shell scripts. Named sh.nix rather than shell.nix or bash.nix because both
# of those aggregate names are already taken by the interactive-shell modules
# under home/shell/ -- see modules/flake/leaves.nix for the naming rule.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bash-language-server # fast-moving: 5.6.0 vs 5.8.1
    shfmt
    shellcheck # also what bash-language-server uses for its diagnostics
  ];
}
