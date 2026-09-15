# Container runtime and the TUI for it.
{ features, ... }:
{
  imports = with features; [
    colima
    lazydocker
  ];
}
