# Login. tuigreet is a TTY greeter, so there is no second display server to
# start before Hyprland does.
#
# `--remember` keeps the username. `--remember-user-session` is deliberately
# NOT set: it overrides `--cmd`, and `programs.hyprland` registers two sessions
# -- hyprland.desktop and hyprland-uwsm.desktop. Picking the uwsm one once is
# enough to lock the account out for good, because uwsm needs the systemd user
# units that `programs.uwsm.enable` installs and this host does not set
# `programs.hyprland.withUWSM`. The session then dies with
#   systemctl --user start wayland-session-bindpid@N.service -> exit 5
# and greetd drops straight back to the greeter, every time.
#
# With the flag gone, `--cmd` is authoritative and the stale remembered path in
# /var/cache/tuigreet is ignored. F3 at the greeter still lists the sessions if
# you ever want to switch on purpose.
{ lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd Hyprland";
      user = "greeter";
    };
  };
}
