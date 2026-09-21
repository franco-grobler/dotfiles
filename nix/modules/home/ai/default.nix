# Coding agents.
{ features, ... }:
{
  imports = with features; [
    claude
    cursor-cli
    opencode
  ];
}
