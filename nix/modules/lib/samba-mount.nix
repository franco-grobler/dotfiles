# A samba share as a local folder, mounted by autofs on first use. One module
# for both system classes; add `samba-mount` to a host's imports, and set
# `dotfiles.sambaMount` there.
#
# Guest access only, so the map holds no secret.
#
# The branch is on `_class`, not `pkgs.stdenv`: which options get defined can't
# depend on pkgs, which itself comes out of config. Neither branch could go
# behind `mkIf` either, as each sets options the other class doesn't have.
#
# macOS gets an activation script rather than `environment.etc`: it owns
# auto_master and puts it back on updates, so the line is re-added on the next
# switch. The map is a real file because automountd can start before the /nix
# volume is mounted, and a link into the store would be dangling then. Dropping
# this from a mac leaves both behind: delete the `/- auto_samba` line from
# /etc/auto_master, remove /etc/auto_samba, and run `sudo automount -vc`.
{
  _class,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.sambaMount;
  user = lib.head (lib.attrNames config.dotfiles.users);

  # automountd mounts as root; `noowners` is what lets the user write.
  macEntry = "${cfg.mountPoint} -fstype=smbfs,soft,noowners,nosuid ://guest:@${cfg.server}/${cfg.share}";
  macMaster = "/- auto_samba -nosuid";
  parent = dirOf cfg.mountPoint;
in
{
  options.dotfiles.sambaMount = {
    server = lib.mkOption {
      type = lib.types.str;
      description = "Host serving the share.";
    };
    share = lib.mkOption {
      type = lib.types.str;
      description = "Name of the share on the server.";
    };
    mountPoint = lib.mkOption {
      type = lib.types.path;
      description = "Local folder the share appears at.";
    };
  };

  config =
    if _class == "darwin" then
      {
        system.activationScripts.postActivation.text = ''
          echo "setting up the samba mount..." >&2
          # automountd would make a missing parent itself, owned by root.
          [ -d '${parent}' ] || install -d -o '${user}' -g staff '${parent}'
          printf '%s\n' '${macEntry}' > /etc/auto_samba
          chmod 644 /etc/auto_samba
          grep -qxF '${macMaster}' /etc/auto_master || printf '%s\n' '${macMaster}' >> /etc/auto_master
          /usr/sbin/automount -c
        '';
      }
    else
      {
        # Puts mount.cifs where autofs's mount looks for it.
        boot.supportedFilesystems.cifs = true;

        services.autofs = {
          enable = true;
          autoMaster = "/- file:${pkgs.writeText "auto.samba" ''
            ${cfg.mountPoint} -fstype=cifs,guest,uid=${user},gid=users,file_mode=0664,dir_mode=0775 ://${cfg.server}/${cfg.share}
          ''}";
        };
      };
}
