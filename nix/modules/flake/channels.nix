# Channel strategy.
#
# Every host picks a *base* channel and gets the other one back as an escape
# hatch, so a module can always reach across:
#
#   pkgs.foo        -> the host's base channel
#   pkgs.unstable.* -> nixpkgs-unstable, on any host
#   pkgs.stable.*   -> nixpkgs (release), on any host
#
# Stable-based hosts additionally get `unstableCherryPicks` promoted to the top
# level, so `pkgs.neovim` is the unstable build everywhere without each module
# having to know which channel its host runs.
#
# All three hosts currently use `channel = "stable"`, because nix-darwin and
# home-manager are pinned to the matching release branch and nix-darwin asserts
# that nixpkgs' release equals its own. To put a host on `channel = "unstable"`,
# move both of those inputs to their `master` branch first:
#
#   home-manager.url = "github:nix-community/home-manager";
#   nix-darwin.url   = "github:nix-darwin/nix-darwin";
{ inputs, ... }:
let
  # Packages that should track unstable even on stable-based hosts.
  unstableCherryPicks = [
    "direnv"
    "gh"
    "neovim"
    "opencode"
    "posting"
    "uv"
  ];

  mkPkgs =
    {
      system,
      channel ? "stable",
      overlays ? [ ],
    }:
    let
      importChannel =
        input:
        import input {
          inherit system;
          config.allowUnfree = true;
        };

      stable = importChannel inputs.nixpkgs;
      unstable = importChannel inputs.nixpkgs-unstable;

      base = if channel == "unstable" then inputs.nixpkgs-unstable else inputs.nixpkgs;

      channelsOverlay = _final: _prev: { inherit stable unstable; };

      cherryPickOverlay =
        _final: prev:
        prev.lib.optionalAttrs (channel != "unstable") (
          prev.lib.genAttrs unstableCherryPicks (name: unstable.${name})
        );
    in
    import base {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        channelsOverlay
        cherryPickOverlay
      ]
      ++ overlays;
    };
in
{
  _module.args.mkPkgs = mkPkgs;
}
