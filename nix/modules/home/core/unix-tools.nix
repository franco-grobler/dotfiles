# The general-purpose command-line kit: things with no configuration of their
# own that you would miss immediately on a bare machine.
{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      bottom
      chafa
      cmatrix
      cowsay
      duf
      eza
      fd
      fzf
      jq
      jqp
      lolcat
      ookla-speedtest
      ripgrep
      scc
      sshs
      stow
      tree
      wget
      wireguard-tools
      yazi
      yq
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [ xclip ];
}
