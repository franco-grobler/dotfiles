{
  pkgs,
  currentSystemUser,
  ...
}:
{
  nix = {
    settings = {
      trusted-users = [
        "root"
        currentSystemUser
      ];
    };
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
