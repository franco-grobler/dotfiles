# Franco's own identity, machines and apps — across every class that needs it.
# Imported by the personal mac and the linux box; never by the work mac.
let
  identity = builtins.fromTOML (builtins.readFile ./identity.toml);
  inherit (identity) signingKey;
in
{ lib, pkgs, ... }:
{
  programs = {
    git = {
      settings.user = {
        inherit (identity) email;
        name = "Franco Grobler";
      };

      signing.key = signingKey;
    };

    # Each attribute name is the `Host` pattern itself, and the address it
    # resolves to goes in `hostname`. A `host = ...` key here would be written
    # out verbatim as a `host` line, which ssh_config reads as the start of a
    # *new* block -- silently swallowing everything under it.
    ssh.settings = {
      "github.com".user = "git";
      "codeberg.org".user = "git";
      "gitlab.com".user = "git";

      bamboo = {
        hostname = "192.168.1.100";
        user = "root";
      };

      openwrt = {
        hostname = "192.168.1.1";
        user = "root";
      };

      bamboo-rescue = {
        hostname = "192.168.99.1";
        user = "root";
      };

      nixos-laptop.hostname = "192.168.10.249";
    };
  };

  # See vcs/git.nix.
  xdg.configFile."git/allowed_signers".text = ''
    ${identity.email} namespaces="git" ${signingKey}
  '';

  dotfiles = {
    # The key each host authenticates with; see core/ssh/. 1Password items are
    # referenced by id because their titles collide with the login items.
    ssh.keys = {
      "github.com" = signingKey;
      "codeberg.org" = "op://Private/fccik27zpnnf24wx4z53wueugy"; # Codeberg
      "gitlab.com" = "op://Private/va5qrbuqdtn5u3roam7skzk4zu"; # GitLab
      openwrt = "op://Private/aeqvst5p5aogunlkfhrvouxzjy"; # OpenWRT
      bamboo = "op://Private/aeqvst5p5aogunlkfhrvouxzjy"; # OpenWRT
      bamboo-rescue = "op://Private/aeqvst5p5aogunlkfhrvouxzjy"; # OpenWRT
      nixos-laptop = "op://Private/bjsy5ygf4gz2smyjddnxveq564"; # NixOs Laptop
    };

    # The picker; the schema is in terminal/sesh.
    sesh.settings = lib.importTOML ./sesh.toml;

    # tmux session layouts for the projects that only exist on the personal
    # machines. Captured from the live sessions these replaced; see
    # terminal/tmuxinator for the schema. Shared projects (Dotfiles) live there.
    sessions = {
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

      "Edge" = {
        root = "~/Code/Tweedill/edge/main/";
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

      "Homelab" = {
        root = "~/Code/Personal/homelab-infra/main/";
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
  };

  home.packages = with pkgs; [
    devbox
    devenv
    qmk
    # sentry-cli
  ];
}
