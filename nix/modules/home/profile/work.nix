# Cloudsmiths identity, apps and tooling. Scoped to the work mac; the personal
# hosts never evaluate it.
#
# The github account is the same one the personal profile uses, so `github.user`
# lives in vcs/git.nix rather than being restated here -- only the email, the
# signing key and the key this machine authenticates with differ.
let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVJfZJqxCPBNQDp1GCcoPRh4ykifHfzlAmedvc13Cm+";
in
{ pkgs, ... }:
{
  programs = {
    git = {
      settings.user = {
        email = "franco.grobler@cloudsmiths.ai";
        name = "Franco Grobler";
      };

      signing.key = signingKey;
    };

    # The attribute name is the `Host` pattern -- see personal.nix.
    ssh.settings."github.com" = {
      user = "git";
      identityFile = "~/.ssh/github/cloudsmiths.pub";
      identitiesOnly = true;
    };
  };

  # Work-only tmux session layouts. Nothing here yet -- none of the sessions
  # captured when this was set up were Cloudsmiths projects. Add entries in the
  # same shape as profile/personal.nix; the schema is in terminal/tmuxinator.
  # Shared projects (Dotfiles) come from there and need no repetition.
  dotfiles.sessions = { };

  home.packages = with pkgs; [
    awscli2
    google-cloud-sdk
    kubectl
    kubernetes-helm
  ];
}
