# Clears the broken links the old stow setup left in ~/.config, before
# home-manager tries to put its own files there.
#
# Stow linked whole folders from the repo root (`~/.config/alacritty ->
# ../dotfiles/alacritty`). Those folders now live under nix/modules/home/, so
# the links point at nothing, and home-manager's `mkdir` for the same path
# fails ("cannot create directory"), followed by the write inside it.
#
# Only links that are both broken *and* point into the dotfiles checkout are
# removed. Stow's links are relative (`../dotfiles/...`); home-manager's are
# absolute, so they never match. A stow link that still resolves is left for
# home-manager's own collision handling (backupFileExtension), and
# `just stow-clean` removes those by hand.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  find = lib.getExe' pkgs.findutils "find";
  configHome = lib.escapeShellArg config.xdg.configHome;
  pattern = lib.escapeShellArg "../*${baseNameOf config.dotfiles.root}/*";
in
{
  home.activation.removeBrokenStowLinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [ -d ${configHome} ]; then
      while IFS= read -r -d "" link; do
        if [ ! -e "$link" ]; then
          echo "Removing broken stow link $link -> $(readlink "$link")"
          run rm -- "$link"
        fi
      done < <(${find} ${configHome} -maxdepth 4 -type l -lname ${pattern} -print0 2>/dev/null)
    fi
  '';
}
