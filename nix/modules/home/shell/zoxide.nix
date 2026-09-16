# `z` jumps to frecent directories; the shell integrations are what actually
# define it, so the bare package is not enough.
{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
