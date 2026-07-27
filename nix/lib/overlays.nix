{ inputs, system }:
let
  unstable = import inputs.nixpkgs-unstable { inherit system; };
in
[
  (final: prev: {
    unstable = unstable;
    inherit (unstable)
      direnv
      gemini-cli
      gh
      neovim
      opencode
      posting
      uv
      ;
  })
]
