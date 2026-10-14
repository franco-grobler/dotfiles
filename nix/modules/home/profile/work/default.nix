# Cloudsmiths identity, apps and tooling. Scoped to the work mac; the personal
# hosts never evaluate it.
#
# Work repos sign and push as the work github account. ~/Code/Personal and the
# dotfiles stay on the personal one (profile/personal/identity.toml): git
# switches email and signing key there, and rewrites github.com remotes to the
# github.com-personal ssh alias, which offers the personal key.
let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVJfZJqxCPBNQDp1GCcoPRh4ykifHfzlAmedvc13Cm+";
  personal = builtins.fromTOML (builtins.readFile ../personal/identity.toml);
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

      includes =
        map
          (dir: {
            condition = "gitdir:${dir}/";
            contents = {
              user = { inherit (personal) email signingKey; };
              url."git@github.com-personal:".insteadOf = "git@github.com:";
              url."ssh://git@github.com-personal/".insteadOf = "ssh://git@github.com/";
            };
          })
          [
            "${config.home.homeDirectory}/Code/Personal"
            config.dotfiles.root
          ];
    };

    # The attribute name is the `Host` pattern -- see profile/personal/.
    ssh.settings = {
      "github.com".user = "git";
      "github.com-personal" = {
        hostname = "github.com";
        user = "git";
      };
    };
  };

  dotfiles = {
    # Each signing key doubles as its account's github auth key. Pinned, so
    # 1Password items listing github.com can't pick or conflict. See core/ssh/.
    ssh.keys = {
      "github.com" = signingKey;
      "github.com-personal" = personal.signingKey;
    };

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
