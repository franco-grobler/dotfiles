# Poking at what the machine is doing.
{ features, ... }:
{
  imports = with features; [
    btop
    htop
    fastfetch
  ];
}
