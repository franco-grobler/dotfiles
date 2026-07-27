{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  home.sessionVariables = {
    LANG = "en_ZA.UTF-8";
    LC_CTYPE = "en_ZA.UTF-8";
    LC_ALL = "en_ZA.UTF-8";

    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    PODMAN_COMPOSE_WARNING_LOGS = "false";

    BAT_CONFIG_PATH = "${config.xdg.configHome}/bat/config";
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";

    FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow";
    PRETTIERD_DEFAULT_CONFIG = "$HOME/.config/prettierd/default.json";

    GEMINI_API_KEY = "op://Personal/Gemini CLI/credential";
  }
  // (
    if isDarwin then
      {
        DISPLAY = "nixpkgs-390751";
      }
    else
      { }
  );
}
