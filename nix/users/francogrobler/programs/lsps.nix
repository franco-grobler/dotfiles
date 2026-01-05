{ pkgs }:
[
  # Python
  pkgs.python313Packages.debugpy
  pkgs.python313Packages.python-lsp-server
  pkgs.ruff
  pkgs.ty

  # JavaScript/TypeScript/Frontend
  pkgs.angular-language-server
  pkgs.biome
  pkgs.nodePackages.eslint_d
  pkgs.nodePackages.prettier
  pkgs.prettierd
  pkgs.typescript-language-server
  pkgs.vue-language-server
  pkgs.vtsls

  # Go
  pkgs.delve
  pkgs.gofumpt
  # pkgs.goimports
  pkgs.gomodifytags
  pkgs.gopls

  # Docker
  pkgs.docker-compose-language-service
  pkgs.docker-language-server
  pkgs.hadolint

  # Shell
  pkgs.bash-language-server
  pkgs.shellcheck
  pkgs.shfmt

  # Markup/Markdown/LaTeX
  pkgs.markdownlint-cli2
  pkgs.marksman
  pkgs.texlab

  # Nix
  pkgs.nil
  pkgs.nixfmt-rfc-style
  pkgs.nixpkgs-fmt

  # YAML/JSON
  pkgs.yaml-language-server
  pkgs.nodePackages.vscode-json-languageserver
  pkgs.taplo

  # Ansible
  # pkgs.ansible-language-server
  # pkgs.ansible-lint

  # Helm
  pkgs.helm-ls

  # SQL
  pkgs.sqlfluff

  # Lua
  pkgs.lua-language-server

  # JVM
  pkgs.java-language-server
  pkgs.vscode-extensions.vscjava.vscode-java-debug
  pkgs.ktlint

  # Other/Generic
  pkgs.prisma
  pkgs.just-lsp
]
