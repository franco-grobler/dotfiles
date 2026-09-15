# Database schema-as-code. A CLI, so nixpkgs rather than the ariga/tap
# formula -- and it follows the unstable cherry-pick list, since the release
# channel lags a minor version behind.
{ pkgs, ... }:
{
  home.packages = [ pkgs.atlas ];
}
