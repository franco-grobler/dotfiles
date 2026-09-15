# Nix daemon settings, expressed once for each system class.
{
  # The Determinate installer owns /etc/nix/nix.conf on these machines, so
  # nix-darwin must not fight it for ownership of the daemon.
  nix.enable = false;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';

  nix.settings = {
    trusted-users = [
      "root"
      "francogrobler"
    ];
    extra-substituters = "https://devenv.cachix.org";
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  };

  ids.gids.nixbld = 30000;
  system.stateVersion = 6;
}
