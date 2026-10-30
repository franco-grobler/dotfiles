{
  pkgs,
  config,
  lib,
  ...
}:
let
  glab = lib.getExe pkgs.glab;
in
{
  home.packages = [ pkgs.glab ];

  xdg.configFile."glab-cli/aliases.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/nix/modules/home/vcs/glab/aliases.yml";

  # glab writes auth state (user, OAuth expiry, keyring fallback tokens) into
  # config.yml, so leave it unmanaged and only seed preferences.
  home.activation.glabConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${glab} config set --global git_protocol ssh
    run ${glab} config set --global editor nvim
    run ${glab} config set --global glamour_style dark
    # Version is pinned by nix, and extra binaries should come from nix too.
    run ${glab} config set --global check_update false
    run ${glab} config set --global show_whats_new false
    run ${glab} config set --global duo_cli_auto_download false
    run ${glab} config set --global orbit_cli_auto_download false
  '';
}
