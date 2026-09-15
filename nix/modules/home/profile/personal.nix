# Franco's own identity, machines and apps — across every class that needs it.
# Imported by the personal mac and the linux box; never by the work mac.
let
  signingKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSIiPwJz9rAYiMlbrbPEqGFyxYIwf4oi7QNENCJPHWCaFWH2Y54PAVh1dt0FTQaDlY92e+fi/QA/QbJrAfoNuuhwVvP/FpZ8a4ihdljhgpBQZpiSTBa6xnA0QMd0fAOQywcazDoMYRaSMpFoOLvxXCZ+W/eoPeifaOQdNk8zs8RmXXj155nLu3hFJ2lEj2ouCuP0jkCh+k0QeoOjVumsSr1CQWn/TIb9kt1msmlWO0/2CTaMT4+q5uAuuDWxB8V2TcjINeOoDGJnkG79Q3N/jtXV09Mstt6W5qP+x62Rod/eZ+gZYVcGYxeLAFj3eTw6neEup1aLI57UbDkGRVzDAw5/KNuhWrtP6ex/V+ZhQUkU8QiQXIbLzWXt351o4G9a5FBncywLob8YLWM4O1OITlz50ciUeWytUNXIuqMlVvzyueJ4c2LCz8KArNU9avhz0F2whBzDMOlWWDOQGS90OIPfxOtHlUx+YY7oFSpdFqZkwu5Dc1+CvNkCM8oSFlLpc=";
in
{ pkgs, ... }:
{
  programs.git.settings = {
    github.user = "franco-from-gcc";
    user = {
      email = "franco@grobler.fyi";
      name = "Franco Grobler";
      inherit signingKey;
    };
  };

  programs.git.signing.key = signingKey;

  programs.ssh.settings = {
    "GitHub- Personal" = {
      host = "github.com";
      user = "git";
      identityFile = "~/.ssh/github/personal.pub";
      identitiesOnly = true;
    };

    "Bamboo- Norm" = {
      host = "192.168.1.100:8006";
      user = "root";
      port = 22;
    };

    "OpenWRT" = {
      host = "192.168.1.1";
      user = "root";
      port = 22;
    };
  };

  home.packages = with pkgs; [
    devbox
    devenv
    qmk
    sentry-cli
  ];
}
