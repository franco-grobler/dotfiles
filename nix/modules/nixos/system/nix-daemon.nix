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
      # The homelab's pull-through cache (homelab-infra, docs/runbooks/nix-cache.md).
      # It advertises priority 10, so it is tried before cache.nixos.org's 40.
      "http://cache.k8s.lab.bamboo.grobler.fyi"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # `nix_cache_public_key` in that repo's group_vars/all.yml.
      "cache.k8s.lab.bamboo.grobler.fyi-1:PvYD0it5/w9fPBsDp0lI1xzr8Twe1jfKcfD2ouR1swY="
    ];
    # Away from home, a cache that does not answer is skipped after this long.
    connect-timeout = 3;
  };

  # Hard-link identical files across the store on a weekly timer.
  nix.optimise.automatic = true;

  environment.localBinInPath = true;
  system.stateVersion = "25.05";
}
