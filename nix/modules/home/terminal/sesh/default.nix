# The picker. sesh lists tmuxinator projects alongside live tmux sessions and
# zoxide's frecent directories, and `connect -T` starts a project through
# tmuxinator when it isn't already running -- so a session costs nothing until
# it is chosen, and choosing it is the same keystroke either way.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.sesh;
  sesh = lib.getExe pkgs.sesh;
  toml = pkgs.formats.toml { };

  # Worktrees come and go with every branch, so they can't be rendered at build
  # time. The scanner writes them to their own file instead, and the picker
  # reruns it on every open -- a worktree added a minute ago is already listed.
  worktreesFile = "${config.xdg.configHome}/sesh/worktrees.toml";
  scanWorktrees = pkgs.writeShellApplication {
    name = "sesh-worktrees";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      git
    ];
    text = builtins.readFile ./worktrees.sh;
  };
  scan = lib.escapeShellArgs (
    [
      (lib.getExe scanWorktrees)
      worktreesFile
      startup
    ]
    ++ cfg.worktreeRoots
  );
  scanning = cfg.worktreeRoots != [ ];

  # Typed into the session's first pane by sesh once the session exists.
  startup = if cfg.worktreeLayout == null then "clear" else "tmux-layout ${cfg.worktreeLayout}";
in
{
  options.dotfiles.sesh = {
    settings = lib.mkOption {
      inherit (toml) type;
      default = { };
      description = ''
        sesh.toml, as nix. Each profile reads its own from profile/<name>/sesh.toml;
        anything set elsewhere merges with it.
      '';
    };

    worktreeRoots = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Directories scanned for git repos; every worktree of each one becomes a
        sesh session named <repo>/<worktree>. Absolute paths.
      '';
    };

    worktreeLayout = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "worktree";
      description = ''
        The dotfiles.layouts entry (see terminal/tmuxinator) a worktree session
        is built out with when sesh starts it. null leaves it a single window.
      '';
    };
  };

  config = {
    home.packages = [ pkgs.sesh ] ++ lib.optional scanning scanWorktrees;

    dotfiles.sesh.settings = lib.mkIf scanning { import = [ worktreesFile ]; };

    # `sesh list -T` reads the tmuxinator projects straight off disk, so the
    # ones rendered by that module show up in the picker with no duplication.
    xdg.configFile."sesh/sesh.toml".source = toml.generate "sesh.toml" cfg.settings;

    # sesh refuses to start when an imported file is missing, so make sure the
    # first switch leaves one behind before the picker is ever opened.
    home.activation.seshWorktrees = lib.mkIf scanning (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${lib.escapeShellArg (dirOf worktreesFile)}
        run ${scan}
      ''
    );

    programs.tmux.extraConfig = ''
      # o -- session picker. -T lists tmuxinator projects; connect -T starts the
      # chosen one through tmuxinator if no such session exists yet.
      bind-key -N "Pick a session" o run-shell -b "${sesh} connect -T \"$(${lib.optionalString scanning "${scan};"} ${sesh} list -T -t -c -z -i -H | ${pkgs.fzf}/bin/fzf-tmux -p 80%,70% --no-sort --ansi --prompt='session> ')\""

      # C-o -- jump back to the previous session. (Plain L is next-window in
      # tmux's keybindings.conf, and o/C-o only shadow tmux's default select-pane.)
      bind-key -N "Last session" C-o run-shell "${sesh} last"
    '';
  };
}
