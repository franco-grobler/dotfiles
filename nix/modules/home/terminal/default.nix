# Terminal emulators and the multiplexer.
{ features, ... }:
{
  imports = with features; [
    ghostty
    alacritty
    tmux
    tmuxinator
    sesh
  ];
}
