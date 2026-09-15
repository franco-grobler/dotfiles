set export := true

default:
    just --list

# Generate Changelog
[group('Chores')]
generate-changelog:
    git cliff -r .

# Add pre-push hook
[group('Git')]
add-hooks:
    cp pre-push.sh .git/hooks/pre-push

# Show which flake output this machine resolves to.
[group('Nix')]
nix-target:
    #!/usr/bin/env bash
    set -euo pipefail
    . ./_scripts/set_nix_envs.sh
    echo "${NIXCONFIG}.${NIXNAME}"

# Build this host's configuration without activating it.
[group('Nix')]
[working-directory("nix")]
nix-build:
    #!/usr/bin/env bash
    set -euo pipefail
    . ../_scripts/set_nix_envs.sh
    case "${NIXCONFIG}" in
      darwinConfigurations) nix build ".#${NIXCONFIG}.${NIXNAME}.system" ;;
      nixosConfigurations)  nix build ".#${NIXCONFIG}.${NIXNAME}.config.system.build.toplevel" ;;
      homeConfigurations)   nix build ".#${NIXCONFIG}.${NIXNAME}.activationPackage" ;;
    esac

# Activate this host's configuration.
[group('Nix')]
[working-directory("nix")]
nix-switch:
    #!/usr/bin/env bash
    set -euo pipefail
    . ../_scripts/set_nix_envs.sh
    echo "Switching to ${NIXCONFIG}.${NIXNAME}"
    case "${NIXCONFIG}" in
      darwinConfigurations) sudo darwin-rebuild switch --flake ".#${NIXNAME}" ;;
      nixosConfigurations)  sudo nixos-rebuild switch --flake ".#${NIXNAME}" ;;
      homeConfigurations)   home-manager switch --flake ".#${NIXNAME}" ;;
    esac

# Dry run: build this host and run its activation checks, without activating.
[group('Nix')]
[working-directory("nix")]
nix-test:
    #!/usr/bin/env bash
    # nix-darwin has no `test`; `check` is the equivalent, and it is what
    # catches things like unexpected files in /etc before a real switch.
    set -euo pipefail
    . ../_scripts/set_nix_envs.sh
    echo "Checking ${NIXCONFIG}.${NIXNAME}"
    case "${NIXCONFIG}" in
      darwinConfigurations) sudo darwin-rebuild check --flake ".#${NIXNAME}" ;;
      nixosConfigurations)  sudo nixos-rebuild test --flake ".#${NIXNAME}" ;;
      homeConfigurations)   home-manager build --flake ".#${NIXNAME}" ;;
    esac

# Evaluate every host, not just this one.
[group('Nix')]
[working-directory("nix")]
nix-check:
    nix flake check

# Format every nix file in the repo.
[group('Nix')]
[working-directory("nix")]
nix-fmt:
    nix fmt

# Raise nix's GitHub fetch rate limit, once per machine.
[group('Nix')]
nix-token item="op://Personal/Nix GitHub PAT/credential":
    #!/usr/bin/env bash
    # Written to the user's nix.conf, outside the repo, so it is never committed.
    set -euo pipefail
    command -v op >/dev/null || { echo "1Password CLI not found" >&2; exit 1; }
    conf="${XDG_CONFIG_HOME:-$HOME/.config}/nix/nix.conf"
    mkdir -p "$(dirname "$conf")"
    umask 077
    printf 'access-tokens = github.com=%s\n' "$(op read "{{ item }}")" >"$conf"
    echo "wrote $conf"
    nix config show access-tokens | sed 's/=.*/= <set>/'

# Update system flake lockfile.
[group('Nix')]
[working-directory("nix")]
nix-update:
    command -v brew >/dev/null 2>&1 && brew update || true
    command -v mas >/dev/null 2>&1 && mas upgrade || true
    nix flake update
    git add-and-commit flake.lock "chore(nix): update nix flake lockfile" || true

# First run on a fresh machine, before darwin-rebuild/nixos-rebuild exist.
[group('Nix')]
[working-directory("nix")]
nix-bootstrap:
    #!/usr/bin/env bash
    set -euo pipefail
    . ../_scripts/set_nix_envs.sh
    case "${NIXCONFIG}" in
      darwinConfigurations)
        nix build ".#${NIXCONFIG}.${NIXNAME}.system"
        sudo ./result/sw/bin/darwin-rebuild switch --flake ".#${NIXNAME}"
        ;;
      *) just nix-switch ;;
    esac

# Set up Claude Code MCP servers.
[group('Dev')]
claude-setup:
    #!/usr/bin/env bash
    if command -v claude >/dev/null; then
      claude mcp list 2>/dev/null | grep -q '^figma-desktop' ||
        claude mcp add --scope user --transport http figma-desktop http://127.0.0.1:3845/mcp
    fi
