{ pkgs }:
{
  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;

      # config = {
      #   map-syntax = [
      #     "*.jenkinsfile:Groovy"
      #   ];
      #   lineNumbers = true;
      #   paging = "less -FR";
      #   theme = "TwoDark";
      # };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
      ];
    };

    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
