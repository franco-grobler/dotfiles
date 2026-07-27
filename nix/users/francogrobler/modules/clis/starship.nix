{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (
      builtins.readFile ../../../../config/starship.toml
    );
  };
}
