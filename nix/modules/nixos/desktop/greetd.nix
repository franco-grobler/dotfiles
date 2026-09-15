# Login. tuigreet is a TTY greeter, so there is no second display server to
# start before Hyprland does.
{ lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.greetd.tuigreet} --time --remember --remember-user-session --cmd Hyprland";
      user = "greeter";
    };
  };
}
