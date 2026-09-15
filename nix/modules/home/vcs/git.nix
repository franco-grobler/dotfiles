# Identity-independent git. `user.*` and the signing key live in the personal /
# work profiles, so the two macs sign as different people while sharing every
# alias and default below.
{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;

  # GitHub is reached over ssh, so this only covers the occasional https
  # remote. Either way it stays off disk: the `store` helper would write the
  # password in cleartext to ~/.git-credentials, which is the one secret in
  # this config that would not live in 1Password.
  credentialHelper = if isDarwin then "osxkeychain" else "cache --timeout=86400";

  opSshSign =
    if isDarwin then
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      lib.getExe' pkgs._1password-cli "op-ssh-sign";
in
{
  programs.git = {
    enable = true;
    settings = {
      alias = {
        cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
        add-and-commit = "!f() { git add \"$1\" && git commit -m \"$2\"; }; f";
        cleanup-untracked = "git rm -r --cache . && git add .";
      };
      branch.autosetuprebase = "always";
      color.ui = true;
      commit.gpgsign = true;
      core.askPass = "";
      credential.helper = credentialHelper;
      gpg.format = "ssh";
      "gpg \"ssh\"".program = opSshSign;
      # One github account for both identities -- work and personal differ by
      # commit email and signing key, not by who they log in as.
      github.user = "franco-grobler";
      init.defaultBranch = "main";
      push.default = "tracking";
    };

    signing = {
      format = "ssh";
      signByDefault = true;
      signer = opSshSign;
    };
  };
}
