set export := true

default:
    just --list

# Regenerate CHANGELOG.md. Run this by hand when cutting a tag -- it is
# deliberately not a git hook: the hook rewrote a tracked file on every push,
# which failed the push and then needed a commit that changed the file again.
[group('Chores')]
generate-changelog:
    git cliff -r .

# Install the git hooks (also done automatically by entering the dev shell).
[group('Git')]
add-hooks:
    #!/usr/bin/env bash
    set -euo pipefail
    nix develop ./nix --command true
    echo "hooks installed"

# Write each ssh host's public key to ~/.ssh/<host>/key.pub (dotfiles.ssh.keys).
[group('Git')]
ssh-keys:
    @_scripts/ssh_keys.sh

# Show which flake output this machine resolves to.
[group('Nix')]
nix-target:
    #!/usr/bin/env bash
    set -euo pipefail
    . ./_scripts/set_nix_envs.sh
    echo "${NIXCONFIG}.${NIXNAME}"

# Build this host's configuration without activating it.
[group('Nix')]
nix-build:
    @_scripts/nix_build.sh

# Activate this host's configuration.
[group('Nix')]
nix-switch:
    @_scripts/nix_switch.sh

# Dry run: build this host and run its activation checks, without activating.
[group('Nix')]
nix-test:
    @_scripts/nix_test.sh

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
nix-token item="op://3qgfzteicksd5qcf74e5wphy7q/4hrgqattsgtiqhrvqd7l5jbese/credential":
    @_scripts/nix_token.sh "{{ item }}"

# Regenerate this machine's hardware-configuration.nix (run on the linux host).
[group('Nix')]
nix-hardware host="":
    @_scripts/nix_hardware.sh "{{ host }}"

# Update system flake lockfile.
[group('Nix')]
nix-update:
    command -v brew >/dev/null 2>&1 && brew update || true
    command -v mas >/dev/null 2>&1 && mas upgrade || true
    nix flake update --flake ./nix
    git add-and-commit nix/flake.lock "chore(nix): update nix flake lockfile" || true

# First run on a fresh machine, before darwin-rebuild/nixos-rebuild exist.
[group('Nix')]
nix-bootstrap:
    @_scripts/nix_bootstrap.sh

# Serve the docs book with live reload.
[group('Docs')]
[working-directory("docs")]
docs:
    mdbook serve --open

# Build the docs book into docs/book/.
[group('Docs')]
[working-directory("docs")]
docs-build:
    mdbook build

# Set up Claude Code MCP servers.
[group('Dev')]
claude-setup:
    #!/usr/bin/env bash
    if command -v claude >/dev/null; then
      claude mcp list 2>/dev/null | grep -q '^figma-desktop' ||
        claude mcp add --scope user --transport http figma-desktop http://127.0.0.1:3845/mcp
    fi
