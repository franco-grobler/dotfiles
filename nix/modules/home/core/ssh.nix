# Host-independent ssh: the 1Password agent. Individual `Host` blocks live in
# the profile that owns them (personal boxes vs. work bastions).
{ pkgs, ... }:
let
  agentPath =
    if pkgs.stdenv.isDarwin then
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "~/.1password/agent.sock";
in
{
  home.packages = [ pkgs._1password-cli ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".identityAgent = ''"${agentPath}"'';
  };
}
