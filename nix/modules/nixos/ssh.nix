# Remote login. Keys only: there is no password to guess and no root shell to
# guess it for.
#
# Which keys belong to whom is not decided here -- it comes from
# `dotfiles.users.<name>.authorizedKeys`, for the same reason group membership
# does, so the host file stays the one place a username is written down.
{ config, lib, ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      # Without this, sshd still offers PAM's interactive prompt and the
      # password is back -- just reached through a different door.
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # `services.openssh.openFirewall` already does this; spelled out because the
  # firewall is otherwise closed and a port that is open deserves to be read.
  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users = lib.mapAttrs (_: user: {
    openssh.authorizedKeys.keys = user.authorizedKeys;
  }) config.dotfiles.users;
}
