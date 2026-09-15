# Coding agents.
{ features, ... }:
{
  imports = with features; [
    claude
    opencode
  ];
}
