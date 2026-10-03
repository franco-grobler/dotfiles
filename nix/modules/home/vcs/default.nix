# Version control.
{ features, ... }:
{
  imports = with features; [
    git
    gh
    glab
    lazygit
    git-cliff
    jujutsu
  ];
}
