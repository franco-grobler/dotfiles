# The home-manager state version, on its own so it is findable.
#
# This is not a "which home-manager am I on" knob -- it is the release whose
# defaults this profile was built against, and bumping it changes behaviour
# for already-migrated state. Leave it alone unless you have read the release
# notes between this value and the one you are moving to.
{
  home.stateVersion = "25.05";
}
