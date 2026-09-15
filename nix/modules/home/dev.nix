# Writing and shipping code.
{ features, ... }:
{
  imports = with features; [
    vcs
    code
    ai
    container
  ];
}
