# What every machine gets.
#
# A bundle is a list of other aggregates and nothing else. If a host wants this
# minus one thing, it skips the bundle and names the groups it wants instead —
# groups and programs are both importable on their own.
{ features, ... }:
{
  imports = with features; [
    core
    shell
  ];
}
