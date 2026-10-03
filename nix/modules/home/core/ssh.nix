# Host-independent ssh: the 1Password agent. Individual `Host` blocks live in
# the profile that owns them (personal boxes vs. work bastions).
#
# The agent offers every key in the vault, and servers give up after ~6 tries
# ("Too many authentication failures"). `dotfiles.ssh.keys` pins a host to one
# key: its public half is written to ~/.ssh/<host>/key.pub by `just ssh-keys`,
# and the host block points at it with IdentitiesOnly, so the agent offers only
# that key. The private half never leaves 1Password.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  agentPath =
    if pkgs.stdenv.isDarwin then
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "~/.1password/agent.sock";
in
{
  options.dotfiles.ssh.keys = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    example = {
      "github.com" = "ssh-ed25519 AAAA...";
      "codeberg.org" = "op://Private/fccik27zpnnf24wx4z53wueugy";
    };
    description = ''
      Host pattern to the public key ssh should offer it. Either the key itself
      or an `op://<vault>/<item>` reference to a 1Password SSH Key item (use the
      item id; titles are often shared with login items). `just ssh-keys`
      writes each to ~/.ssh/<host>/key.pub.
    '';
  };

  config = {
    home.packages = [ pkgs._1password-cli ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*".identityAgent = ''"${agentPath}"'';
      }
      // lib.mapAttrs (host: _: {
        identityFile = "~/.ssh/${host}/key.pub";
        identitiesOnly = true;
      }) config.dotfiles.ssh.keys;
    };
  };
}
