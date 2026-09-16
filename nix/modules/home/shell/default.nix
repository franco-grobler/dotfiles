# Interactive shells and everything that decorates them.
{ features, ... }:
{
  imports = with features; [
    zsh
    bash
    nushell
    shell-aliases
    starship
    atuin
    carapace
    direnv
    zoxide
    just
  ];
}
