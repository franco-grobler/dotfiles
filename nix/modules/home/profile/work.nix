# Work identity, apps and tooling. Scoped to the work mac; the personal hosts
# never evaluate it.
#
# TODO(franco): fill in the real work email, github handle and signing key. The
# placeholders below evaluate fine but will attribute commits to the wrong
# address until you replace them.
{ pkgs, lib, ... }:
{
  programs.git.settings = {
    github.user = "Franco-from-Owlish";
    user = {
      email = "franco@owlish.example";
      name = "Franco Grobler";
    };

    # No work signing key configured yet — signing stays off rather than
    # silently falling back to the personal key.
    commit.gpgsign = lib.mkForce false;
  };

  programs.git.signing.signByDefault = lib.mkForce false;

  programs.ssh.settings."GitHub- Work" = {
    host = "github.com";
    user = "git";
    identityFile = "~/.ssh/github/work.pub";
    identitiesOnly = true;
  };

  home.packages = with pkgs; [
    awscli2
    google-cloud-sdk
    kubectl
    kubernetes-helm
  ];
}
