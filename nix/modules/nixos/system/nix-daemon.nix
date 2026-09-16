{ config, lib, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    keep-outputs = true;
    keep-derivations = true;
    # NixOS already defaults this to [ "root" ]; the list merges.
    trusted-users = lib.attrNames config.dotfiles.users;
    # nix-community serves the unstable cherry-picks (channels.nix) and the
    # community tooling; without it this host rebuilds them from source.
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  environment.localBinInPath = true;
  system.stateVersion = "25.05";
}
