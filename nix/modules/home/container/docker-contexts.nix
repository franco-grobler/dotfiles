# Docker contexts, declared instead of `docker context create`d. The CLI keeps
# each one at ~/.docker/contexts/meta/<sha256 of name>/meta.json and only ever
# writes there on create/update/rm, so a read-only store symlink is fine -- it
# just means `docker context rm lab` fails until the entry leaves this list.
# Which context is *current* lives in ~/.docker/config.json, which docker and
# colima both rewrite, so that stays imperative: `docker context use lab`.
{ config, lib, ... }:
{
  options.dotfiles.docker.contexts = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    example = {
      lab = "ssh://dev@builder.example.com";
    };
    description = ''
      Context name to the docker endpoint it talks to. `ssh://` hosts go
      through the system ssh, so the host's ssh config (and key) applies.
    '';
  };

  config.home.file = lib.mapAttrs' (
    name: host:
    lib.nameValuePair ".docker/contexts/meta/${builtins.hashString "sha256" name}/meta.json" {
      text = builtins.toJSON {
        Name = name;
        Metadata.Description = "";
        Endpoints.docker = {
          Host = host;
          SkipTLSVerify = false;
        };
      };
    }
  ) config.dotfiles.docker.contexts;
}
