# Everything the linux box needs to boot into a graphical session.
{ features, ... }:
{
  imports = with features; [
    hyprland
    greetd
    audio
  ];
}
