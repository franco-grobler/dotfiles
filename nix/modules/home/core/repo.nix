# Where this repo is checked out, as one option instead of a string repeated in
# every module that needs to point back at it.
#
# Two things genuinely need the working copy rather than the store: `nh`, which
# takes a flake reference, and the neovim config, which is symlinked live so
# lazy.nvim can keep owning its lockfile. Both read it from here, so moving the
# checkout is one `dotfiles.root` override on the host.
{ config, lib, ... }:
{
  options.dotfiles.root = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/dotfiles";
    description = ''
      Absolute path to the dotfiles working copy on this machine. Used for the
      things that must reference the checkout itself rather than the store.
    '';
  };
}
