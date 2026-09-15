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
    # Not a real display. The NixOS test driver appends `-nographic` to qemu
    # whenever neither DISPLAY nor WAYLAND_DISPLAY is set, which on macOS is
    # always -- so `runNixOSTest`'s interactive driver never opens a window.
    # Any non-empty value defeats the check; this one names the issue.
    # https://github.com/NixOS/nixpkgs/issues/390751
    DISPLAY = "nixpkgs-390751";
  };
}
