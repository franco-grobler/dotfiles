# Claude Code writes to its own settings.json -- `/plugin` stores marketplaces
# and enabled plugins there -- so a read-only store symlink makes those
# operations fail. `mkOutOfStoreSymlink` keeps the file declarative while
# leaving it writable: edits from either side land in the working copy, and
# `git diff` shows what the tool changed.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # macOS gets Claude Code from Homebrew (claude-code@latest cask); install
  # the nix build everywhere else.
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.claude-code ];

  home.sessionVariables.CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";

  xdg.configFile."claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/nix/modules/home/ai/claude/settings.json";
}
