# Omarchy-style helpers: keybinding cheatsheet and system menu.
#
# Both are plain Walker dmenu wrappers so they follow the Tokyo Night Walker
# theme with no extra styling. Keybindings live in hyprland.nix:
#   Super+K              -> omarchy-show-keybindings
#   Super+Alt+Space      -> omarchy-menu (also the Waybar logo click)
{ pkgs, ... }:
let
  showKeybindings = pkgs.writeShellScriptBin "omarchy-show-keybindings" ''
    set -euo pipefail
    conf="$HOME/.config/hypr/hyprland.conf"
    [[ -f $conf ]] || { echo "hyprland.conf not found at $conf" >&2; exit 1; }
    grep -h '^[[:space:]]*bind' "$conf" |
      awk -F, '
      {
        sub(/#.*/, "");
        sub(/^[[:space:]]*bind[elm]*[[:space:]]*=[[:space:]]*/, "", $1);
        key_combo = $1 " + " $2;
        gsub(/^[ \t]+|[ \t]+$/, "", key_combo);
        gsub(/[ \t]+/, " ", key_combo);
        action = "";
        for (i = 3; i <= NF; i++) {
          action = action $i (i < NF ? "," : "");
        }
        sub(/^[[:space:]]*exec[[:space:]]*,?[[:space:]]*/, "", action);
        gsub(/^[ \t]+|[ \t]+$/, "", action);
        if (key_combo != "" && action != "") {
          printf "%-35s → %s\n", key_combo, action;
        }
      }' |
      walker --dmenu --prompt "Hyprland Keybindings…"
  '';

  menu = pkgs.writeShellScriptBin "omarchy-menu" ''
    set -euo pipefail
    choice=$(printf '%s\n' \
      "Launcher (Super+Space)" \
      "Keybindings (Super+K)" \
      "Clipboard (Ctrl+Super+V)" \
      "Screenshot region" \
      "Screenshot window" \
      "Screenshot output" \
      "Colour picker" \
      "Toggle waybar" \
      "Lock (Super+Esc)" \
      "Exit Hyprland (Super+Shift+Esc)" \
      "Reboot (Super+Ctrl+Esc)" \
      "Power off (Super+Shift+Ctrl+Esc)" \
      | walker --dmenu --prompt "Omarchy…")

    case "$choice" in
      "Launcher"*) walker ;;
      "Keybindings"*) omarchy-show-keybindings ;;
      "Clipboard"*) ghostty --class clipse -e clipse ;;
      "Screenshot region") hyprshot -m region ;;
      "Screenshot window") hyprshot -m window ;;
      "Screenshot output") hyprshot -m output ;;
      "Colour picker") hyprpicker -a ;;
      "Toggle waybar") pkill -SIGUSR1 waybar ;;
      "Lock"*) hyprlock ;;
      "Exit"*) hyprctl dispatch exit ;;
      "Reboot"*) reboot ;;
      "Power off"*) systemctl poweroff ;;
      *) exit 0 ;;
    esac
  '';
in
{
  home.packages = [
    showKeybindings
    menu
  ];
}
