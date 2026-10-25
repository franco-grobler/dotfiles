# Pins the Bonjour name to the host's filename, which is also how
# _scripts/set_nix_envs.sh finds this machine's configuration. macOS renames
# itself (Name-2) when it sees a clash on the network; every switch puts the
# name back.
{ hostName, ... }:
{
  networking.localHostName = hostName;
}
