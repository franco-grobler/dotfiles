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

# Bootstrap nix config for the first time.
[group('Nix')]
nix-bootstrap:
    #!/usr/bin/env bash
    set -euo pipefail
    just nix-switch

# Update system config.
[group('Nix')]
[working-directory("nix")]
nix-switch:
    #!/usr/bin/env bash
    set -euo pipefail
    . ../_scripts/set_nix_envs.sh
    echo "Update nix config with: "
    printenv | grep "^NIX[^_]"
    nix build ".#${NIXCONFIG}.${NIXNAME}.system"
    sudo ./result/sw/bin/darwin-rebuild switch --flake "$(pwd)#${NIXNAME}"

# Test home manager flake.
[group('Nix')]
[working-directory("nix")]
nix-test:
    #!/usr/bin/env bash
    set -euxo pipefail
    . ../_scripts/set_nix_envs.sh
    echo "Test nix config with: "
    printenv | grep "^NIX[^_]"
    nix build ".#${NIXCONFIG}.${NIXNAME}.system"
    sudo ./result/sw/bin/darwin-rebuild test --flake "$(pwd)#${NIXNAME}"

# Update system flake lockfile.
[group('Nix')]
[working-directory("nix")]
nix-update:
    command -v brew >/dev/null 2>&1 && brew update || true
    command -v mas >/dev/null 2>&1 && mas upgrade || true
    nix flake update
    git add-and-commit nix/flake.lock "chore(nix): update nix flake lockfile" || true

# Bootstrap nix config for the first time.
[group('Nix')]
nix-bootstrap:
    just nix-switch

# Set up Claude Code MCP servers.
[group('Dev')]
claude-setup:
    #!/usr/bin/env bash
    if command -v claude >/dev/null; then
      claude mcp list 2>/dev/null | grep -q '^figma-desktop' ||
        claude mcp add --scope user --transport http figma-desktop http://127.0.0.1:3845/mcp
    fi
