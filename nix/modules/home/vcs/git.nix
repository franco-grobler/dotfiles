# Identity-independent git. `user.*` and the signing key live in the personal /
# work profiles, so the two macs sign as different people while sharing every
# alias and default below.
{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
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
      credential.helper = "store";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = opSshSign;
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
