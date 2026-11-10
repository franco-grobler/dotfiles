{ lib, ... }:
let
  # Private @tweedill/* packages live on the homelab Forgejo. The scope mapping
  # and its auth both go in ~/.npmrc, so every project resolves them.
  tweedillRegistry = "//forgejo.apps.lab.bamboo.grobler.fyi/api/packages/tweedill/npm/";

  # npm, npx, pnpm and pnpx resolve $TWEEDILL_NPM_TOKEN from its op:// reference
  # the first time one of them runs, then keep the value in the shell's
  # environment, so op prompts once per shell rather than at every startup or
  # every install. If op fails, the reference stays and the command still runs,
  # just without access to the private scope.
  opWrappers = ''
    __tweedill_npm_token() {
      case "$TWEEDILL_NPM_TOKEN" in
        op://*)
          local token
          if token=$(op read "$TWEEDILL_NPM_TOKEN"); then
            export TWEEDILL_NPM_TOKEN="$token"
          else
            echo "op: could not read TWEEDILL_NPM_TOKEN; @tweedill/* will 401" >&2
          fi
          ;;
      esac
    }
    npm() { __tweedill_npm_token; command npm "$@"; }
    npx() { __tweedill_npm_token; command npx "$@"; }
    pnpm() { __tweedill_npm_token; command pnpm "$@"; }
    pnpx() { __tweedill_npm_token; command pnpx "$@"; }
  '';
in
{
  xdg.configFile."pnpm/config.yaml".source = ./config.yaml;

  # Always set, even before it is resolved: npm refuses to load an .npmrc that
  # names an undefined variable, which would break plain public installs run
  # outside the wrappers (editors, scripts).
  home.sessionVariables.TWEEDILL_NPM_TOKEN = "op://bamboo/Tweedill npm read/password";

  programs.zsh.initContent = opWrappers;
  programs.bash.initExtra = opWrappers;

  # ~/.npmrc holds other registries' auth, so leave it unmanaged and only make
  # sure the lines are there. The auth keeps the literal ${TWEEDILL_NPM_TOKEN}:
  # npm and pnpm expand it at read time, so the token never touches disk.
  home.activation.tweedillNpmrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for line in \
      '@tweedill:registry=https:${tweedillRegistry}' \
      '${tweedillRegistry}:_authToken=''${TWEEDILL_NPM_TOKEN}'; do
      if ! grep -qxF "$line" "$HOME/.npmrc" 2>/dev/null; then
        run touch "$HOME/.npmrc"
        run chmod 600 "$HOME/.npmrc"
        if [ -z "''${DRY_RUN:-}" ]; then
          printf '%s\n' "$line" >>"$HOME/.npmrc"
        fi
      fi
    done
  '';
}
