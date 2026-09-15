# Declares `flake.modules.<class>.<name>` as a proper lazy option tree.
#
# Without this, flake-parts treats `flake.modules` as an opaque freeform output
# and deep-merges it, which forces every aggregate's `imports` while it is still
# computing attribute names — an immediate infinite recursion, since aggregates
# are defined in terms of each other.
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
