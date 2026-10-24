# Mole (`mo`) is the macOS cleaner: `mo clean` for caches, logs and leftovers of
# uninstalled apps, `mo purge` for build artifacts inside projects. The binary
# comes from homebrew (darwin/profile/*); this is only its config.
#
# There is deliberately no whitelist here. Mole's built-in defaults already
# protect what is expensive to rebuild (playwright browsers, gradle, JetBrains),
# and a whitelist file *replaces* those defaults rather than adding to them.
#
# Mole knows nothing about the XDG-placed stores this config uses (nix, the
# pnpm store under ~/.local/share, rustup, GOMODCACHE), so it does not replace
# their own pruning -- nh clean, `pnpm store prune`, cargo-sweep.
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  # `mo purge --paths` edits this file in place, so it is linked out of the
  # store like colima.yaml: writable, and any change shows up in `git diff`.
  xdg.configFile."mole/purge_paths".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/nix/modules/home/core/mole/purge_paths";
}
