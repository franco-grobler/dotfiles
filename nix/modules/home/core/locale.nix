# Language, paging and the handful of session variables that are not owned by
# any single tool.
{ pkgs, lib, ... }:
{
  home.sessionVariables = {
    LANG = "en_ZA.UTF-8";
    LC_CTYPE = "en_ZA.UTF-8";
    LC_ALL = "en_ZA.UTF-8";

    PAGER = "less -FirSwX";

    FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow";
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    DISPLAY = "nixpkgs-390751";
  };
}
