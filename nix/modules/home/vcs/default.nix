# Version control.
{ features, ... }:
{
  imports = with features; [
    git
    gh
    lazygit
    git-cliff
    jujutsu
  ];
}
