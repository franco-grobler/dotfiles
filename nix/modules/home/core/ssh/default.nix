# Host-independent ssh: the 1Password agent. Individual `Host` blocks live in
# the profile that owns them (personal boxes vs. work bastions).
#
# The agent offers every key in the vault, and servers give up after ~6 tries
# ("Too many authentication failures"). So each host gets one key: `just
# ssh-keys` writes the public half of every 1Password SSH key to
# ~/.ssh/<host>/key.pub, taking the hosts from the item's URLs, and the Match
# block below makes ssh offer only that key whenever the file exists. The
# private half never leaves 1Password.
{ lib, pkgs, ... }:
let
  agentPath =
    if pkgs.stdenv.isDarwin then
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "~/.1password/agent.sock";
in
{
  options.dotfiles.ssh = {
    keys = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        "github.com" = "ssh-ed25519 AAAA...";
        "codeberg.org" = "op://Private/fccik27zpnnf24wx4z53wueugy";
      };
      description = ''
        Host to the public key ssh should offer it, overriding whatever the
        1Password item URLs say -- for a host two keys claim, or an alias no
        item lists. Either the key itself or an `op://<vault>/<item>` reference
        to a 1Password SSH Key item (use the item id; titles are often shared
        with login items).
      '';
    };

    ignore = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "Old laptop"
        "gitlab.com"
      ];
      description = ''
        1Password item ids, item titles or hosts `just ssh-keys` skips.
      '';
    };
  };

  config = {
    home.packages = [ pkgs._1password-cli ];

    xdg.configFile."1Password/ssh/agent.toml".source = ./agent.toml;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*".identityAgent = ''"${agentPath}"'';

        # %n is the host as typed, so an alias (github.com-personal) gets its
        # own key rather than the one for the hostname it resolves to.
        "Match exec \"test -f ~/.ssh/%n/key.pub\"" = {
          identityFile = "~/.ssh/%n/key.pub";
          identitiesOnly = true;
        };
      };
    };
  };
}
