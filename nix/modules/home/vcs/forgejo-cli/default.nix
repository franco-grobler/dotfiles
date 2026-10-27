# fj, the Forgejo CLI (Codeberg and friends).
{ pkgs, ... }:
{
  home.packages = [ pkgs.forgejo-cli ];

  # OAuth app ids for instances fj doesn't ship one for. Logins themselves land
  # in keys.json under the data dir, which fj rewrites on every token refresh,
  # so that stays unmanaged.
  xdg.configFile."forgejo-cli/client_ids".source = ./client_ids;

  # Used outside a repo, or in one whose remotes aren't on a known forge: the
  # homelab instance. Codeberg repos are still picked up from their remotes.
  home.sessionVariables.FJ_FALLBACK_HOST = "https://forgejo.apps.lab.bamboo.grobler.fyi";
}
