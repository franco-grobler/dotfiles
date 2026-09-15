# Franco's own identity, machines and apps — across every class that needs it.
# Imported by the personal mac and the linux box; never by the work mac.
let
  signingKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSIiPwJz9rAYiMlbrbPEqGFyxYIwf4oi7QNENCJPHWCaFWH2Y54PAVh1dt0FTQaDlY92e+fi/QA/QbJrAfoNuuhwVvP/FpZ8a4ihdljhgpBQZpiSTBa6xnA0QMd0fAOQywcazDoMYRaSMpFoOLvxXCZ+W/eoPeifaOQdNk8zs8RmXXj155nLu3hFJ2lEj2ouCuP0jkCh+k0QeoOjVumsSr1CQWn/TIb9kt1msmlWO0/2CTaMT4+q5uAuuDWxB8V2TcjINeOoDGJnkG79Q3N/jtXV09Mstt6W5qP+x62Rod/eZ+gZYVcGYxeLAFj3eTw6neEup1aLI57UbDkGRVzDAw5/KNuhWrtP6ex/V+ZhQUkU8QiQXIbLzWXt351o4G9a5FBncywLob8YLWM4O1OITlz50ciUeWytUNXIuqMlVvzyueJ4c2LCz8KArNU9avhz0F2whBzDMOlWWDOQGS90OIPfxOtHlUx+YY7oFSpdFqZkwu5Dc1+CvNkCM8oSFlLpc=";
in
{ pkgs, ... }:
{
  programs = {
    git = {
      settings.user = {
        email = "franco@grobler.fyi";
        name = "Franco Grobler";
      };

      signing.key = signingKey;
    };

    # Each attribute name is the `Host` pattern itself, and the address it
    # resolves to goes in `hostname`. A `host = ...` key here would be written
    # out verbatim as a `host` line, which ssh_config reads as the start of a
    # *new* block -- silently swallowing everything under it.
    ssh.settings = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/github/personal.pub";
        identitiesOnly = true;
      };

      bamboo = {
        hostname = "192.168.1.100";
        user = "root";
      };

      openwrt = {
        hostname = "192.168.1.1";
        user = "root";
      };
    };
  };

  # tmux session layouts for the projects that only exist on the personal
  # machines. Captured from the live sessions these replaced; see
  # terminal/tmuxinator for the schema. Shared projects (Dotfiles) live there.
  dotfiles.sessions = {
    "Anke van Zyl" = {
      root = "~/Code/Tweedill/anke-van-zyl/anke-van-zyl-website";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "main-vertical";
          panes = [
            "."
            "."
            "."
          ];
        }
      ];
    };

    "Costing calculator" = {
      root = "~/Code/GrowCreativeCo/costing-calculator";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "main-vertical";
          panes = [
            "."
            "src-tauri"
            "."
          ];
        }
      ];
    };

    "Cowsay" = {
      root = "~/Code/Personal/cowsay-rs";
      windows = [
        { name = "editor"; }
        { name = "shell"; }
      ];
    };

    # Three git worktrees of the same repo, one window each.
    "Khula" = {
      root = "~/Code/GrowCreativeCo/Khula/khula/feat/hookup";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "main-vertical";
          panes = [
            "."
            "."
            "."
          ];
        }
        {
          name = "dashboard";
          root = "~/Code/GrowCreativeCo/Khula/khula/feat/dashboard";
        }
        {
          name = "llm-integration";
          root = "~/Code/GrowCreativeCo/Khula/khula/feat/llm-integration";
        }
      ];
    };

    "MSc" = {
      root = "~/Documents/University/Masters of Computer Science/Thesis/Report.nosync";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "even-horizontal";
          panes = [
            "."
            "."
          ];
        }
      ];
    };

    "Personal site" = {
      root = "~/Code/Personal/franco-grobler.github.io";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "even-horizontal";
          panes = [
            "."
            "."
          ];
        }
        {
          name = "portfolio";
          root = "~/Code/Personal/porfolio";
        }
      ];
    };

    "Streamy backend" = {
      root = "~/Documents/University/Masters of Computer Science/Thesis/Code.nosync/streamy-backend";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "even-horizontal";
          panes = [
            "."
            "."
          ];
        }
      ];
    };

    "go-api-gen" = {
      root = "~/Code/Personal/go-api-gen/main";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "even-horizontal";
          panes = [
            "."
            "."
          ];
        }
      ];
    };

    # Was a fourth window on the Dotfiles session; split out so the shared
    # Dotfiles project stays valid on the work mac, which has no qmk checkout.
    "QMK" = {
      root = "~/qmk_firmware";
      windows = [
        { name = "editor"; }
        {
          name = "dev";
          layout = "even-horizontal";
          panes = [
            "."
            "~/dotfiles"
          ];
        }
      ];
    };
  };

  home.packages = with pkgs; [
    devbox
    devenv
    qmk
    sentry-cli
  ];
}
