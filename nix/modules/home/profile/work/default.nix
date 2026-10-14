# Cloudsmiths identity, apps and tooling. Scoped to the work mac; the personal
# hosts never evaluate it.
#
# The github account is the same one the personal profile uses, so `github.user`
# lives in vcs/git.nix rather than being restated here -- only the email, the
# signing key and the key this machine authenticates with differ.
let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVJfZJqxCPBNQDp1GCcoPRh4ykifHfzlAmedvc13Cm+";
in
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs = {
    git = {
      settings.user = {
        email = "franco.grobler@cloudsmiths.ai";
        name = "Franco Grobler";
      };

      signing.key = signingKey;
    };

    # The attribute name is the `Host` pattern -- see profile/personal/.
    ssh.settings."github.com".user = "git";
  };

  dotfiles = {
    # The signing key doubles as the github auth key; see core/ssh/.
    ssh.keys."github.com" = signingKey;

    # Work-only tmux session layouts. Nothing here yet -- none of the sessions
    # captured when this was set up were Cloudsmiths projects. Add entries in the
    # same shape as profile/personal/; the schema is in terminal/tmuxinator.
    # Shared projects (Dotfiles) come from there and need no repetition.
    sessions = { };

    # The picker: sesh.toml next to this file, plus a session for every repo +
    # worktree under the roots. The schema is in terminal/sesh.
    sesh = {
      settings = lib.importTOML ./sesh.toml;
      worktreeRoots = [ "${config.home.homeDirectory}/Code/Cloudsmiths" ];
    };
  };

  home.packages = with pkgs; [
    google-cloud-sdk
    kubectl
    kubernetes-helm

    # Carried over from the old work setup (branch feat/cloudsmiths), so the
    # switch doesn't take them off PATH.
    devbox
    devenv
    gemini-cli # the homebrew formula is deprecated
    gnumake
    gnused
    hyperfine
    qmk
    uv
  ];
}
