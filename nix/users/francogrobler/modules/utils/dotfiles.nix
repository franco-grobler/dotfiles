{ config, ... }:
{
  xdg.configFile = {
    "thefuck/settings.py".source = ../../../../../thefuck/settings.py;
    "gh/config.yml".source = ../../../../../gh/config.yml;
    "gh/hosts.yml".source = ../../../../../gh/hosts.yml;
    "prettierd/default.json".source = ../../../../../prettierd/default.json;
    "dlv/config.yml".source = ../../../../../dlv/config.yml;
    "octave/octave-gui.ini".source = ../../../../../octave/octave-gui.ini;
    "pnpm/config.yaml".source = ../../../../../pnpm/config.yaml;
    "claude/settings.json".source = ../../../../../claude/settings.json;
    "colima/default/colima.yaml".source = ../../../../../colima/default/colima.yaml;
    "colima/ssh_config".source = ../../../../../colima/ssh_config;
    "posting/config.yaml".source = ../../../../../posting/config.yaml;
    "opencode/opencode.jsonc".source = ../../../../../opencode/opencode.jsonc;
    "lazysql/config.toml".source = ../../../../../lazysql/config.toml;
    "alacritty/alacritty.toml".source = ../../../../../alacritty/alacritty.toml;
    "alacritty/themes/google.toml".source =
      ../../../../../alacritty/themes/google.toml;
    "zsh/zshrc".source = ../../../../../zsh/zshrc;
  };
}
