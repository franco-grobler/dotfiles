# Native dockerd. The macs run colima instead, because they have no choice; here
# the daemon runs directly on the host with no VM in the way.
#
# `pkgs.docker` ships buildx and compose as CLI plugins, so `docker buildx` and
# `docker compose` work without anything extra.
{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Group membership lives with the module that creates the group, so a host
  # that skips docker never ends up referencing a group that does not exist.
  users.users.francogrobler.extraGroups = [ "docker" ];
}
