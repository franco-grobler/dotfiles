# Python.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python314

    # `ty` is the language server, picked in nvim/lua/config/options.lua;
    # ruff covers both lint and format. Both are pre-1.0 Astral tools on a
    # weekly cadence, so nixpkgs trails them by a lot.
    ty # fast-moving: 0.0.38 here vs 0.0.82 upstream -- 44 releases
    ruff # fast-moving: 0.15.14 vs 0.16.8
  ];
}
