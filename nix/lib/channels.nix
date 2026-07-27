{ inputs }:
{
  system,
  channelBase ? "stable",
}:
let
  unstablePkgs = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  stablePkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  unstableCherryPicks = import ./overlays.nix { inherit inputs system; };
  stableOverlay = [
    (final: prev: {
      stable = stablePkgs;
    })
  ];
in
if channelBase == "unstable" then
  {
    basePkgs = unstablePkgs;
    overlays = stableOverlay;
  }
else
  {
    basePkgs = stablePkgs;
    overlays = unstableCherryPicks;
  }
