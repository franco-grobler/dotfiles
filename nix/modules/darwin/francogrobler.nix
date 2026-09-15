# The account, plus the home-manager hand-off. A host saying `francogrobler` is
# saying "this machine is Franco's, wire his home config up".
{ features, pkgs, ... }:
{
  imports = [ features.home-manager ];

  users.users.francogrobler = {
    description = "Franco Grobler";
    home = "/Users/francogrobler";
    shell = pkgs.zsh;
  };

  system.primaryUser = "francogrobler";
}
