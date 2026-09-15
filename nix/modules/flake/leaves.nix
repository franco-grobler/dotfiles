# The loader. This is the only file in the repo that mentions `flake.modules`.
#
# Everything under modules/{home,darwin,nixos} is a plain module of its class —
# no `flake.modules.homeManager.foo = ...` wrapper anywhere. The aggregate name
# comes from the path instead:
#
#   home/vcs/git.nix               ->  flake.modules.homeManager.git
#   home/vcs/lazygit/default.nix   ->  flake.modules.homeManager.lazygit
#   home/vcs/default.nix           ->  flake.modules.homeManager.vcs
#   darwin/hosts/air.nix           ->  flake.modules.darwin."hosts/air"
#   nixos/hosts/box/default.nix    ->  flake.modules.nixos."hosts/box"
#
# Folders are for reading, not for naming: a file is named after itself wherever
# it sits, so moving a program between folders never breaks an import. Three
# rules shape the rest:
#
#   * `default.nix` is named after its folder. That is what makes a folder work
#     both as a group of programs (`vcs/`) and as one program plus the config
#     files it ships (`vcs/lazygit/`).
#   * anything under `hosts/` gets that prefix, so `configurations.nix` can find
#     it.
#   * a host folder is one machine, so only its `default.nix` is an aggregate —
#     `hardware-configuration.nix` next to it stays private to that host.
{ lib, ... }:
let
  collect =
    dir:
    let
      # depth: null outside hosts/, 0 in hosts/ itself, >=1 inside one host.
      walk =
        depth: folder: sub:
        lib.concatLists (
          lib.mapAttrsToList (
            entry: type:
            let
              path = sub + "/${entry}";
              stem = lib.removeSuffix ".nix" entry;
              descend = if depth == null then (if entry == "hosts" then 0 else null) else depth + 1;
            in
            if type == "directory" then
              walk descend entry path
            else if entry == "default.nix" then
              lib.optional (folder != null) (
                lib.nameValuePair (if depth == 1 then "hosts/${folder}" else folder) path
              )
            else if !(lib.hasSuffix ".nix" entry) then
              [ ]
            else if depth == null then
              [ (lib.nameValuePair stem path) ]
            else if depth == 0 then
              [ (lib.nameValuePair "hosts/${stem}" path) ]
            else
              # Private to the host folder it sits in.
              [ ]
          ) (builtins.readDir sub)
        );
    in
    walk null null dir;

  mkClass =
    label: dir:
    let
      entries = collect dir;
      names = map (e: e.name) entries;
      dupes = lib.unique (lib.filter (n: lib.count (x: x == n) names > 1) names);
    in
    if dupes == [ ] then
      lib.listToAttrs entries
    else
      throw "modules/${label}: aggregate name defined more than once: ${lib.concatStringsSep ", " dupes}";
in
{
  flake.modules = {
    homeManager = mkClass "home" ../home;
    darwin = mkClass "darwin" ../darwin;
    nixos = mkClass "nixos" ../nixos;
  };
}
