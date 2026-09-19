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
#
# `--cmd` must be `start-hyprland`, not bare `Hyprland`: upstream's
# hyprland.desktop session Execs the start-hyprland watchdog (env setup,
# readiness tracking, crash recovery), and Hyprland warns on startup when it is
# launched without it. Both binaries ship in the same programs.hyprland package,
# so PATH resolution is identical.
{ lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd start-hyprland";
      user = "greeter";
    };
  };
}
