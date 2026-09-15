{ features, ... }:
{
  imports = with features; [
    system
    homebrew
  ];
}
