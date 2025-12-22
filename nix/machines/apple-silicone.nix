{ _, ... }:
{
  # Set in May 2025 as part of the macOS Sequoia release.
  system.stateVersion = 6;

  # This makes it work with the Determinate Nix installer
  ids.gids.nixbld = 30000;

  # We use proprietary software on this machine
  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = false;
    # We need to enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    settings = {
      trusted-users = [
        "root"
        "francogrobler"
      ];
      extra-substituters = "https://devenv.cachix.org";
      extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    };
  };
}
