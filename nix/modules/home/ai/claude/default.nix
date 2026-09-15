{ config, ... }:
{
  home.sessionVariables.CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
  xdg.configFile."claude/settings.json".source = ./settings.json;
}
