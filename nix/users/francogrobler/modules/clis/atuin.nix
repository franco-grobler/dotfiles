{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      dialect = "uk";
      timezone = "local";
      filter_mode = "global";
      filter_mode_shell_up_key_binding = "directory";
      style = "full";
      inline_height = 20;
      ctrl_n_shortcuts = false;
      history_filter = [
        "op://"
        "^cl\\s.$"
      ];
      show_help = true;
      show_tabs = true;
      secrets_filter = true;
      enter_accept = true;
      keymap_mode = "vim-normal";
      stats = {
        common_prefix = [ "sudo" ];
        ignored_commands = [
          "cd"
          "ls"
          "vi"
          "l"
          "cl"
          "clear"
        ];
      };
      sync = {
        records = true;
      };
    };
  };
}
