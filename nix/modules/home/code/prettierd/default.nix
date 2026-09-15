{ config, ... }:
{
  home.sessionVariables.PRETTIERD_DEFAULT_CONFIG = "${config.xdg.configHome}/prettierd/default.json";
  xdg.configFile."prettierd/default.json".source = ./default.json;
}
