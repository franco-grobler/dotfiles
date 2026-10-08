# Rust: rustup, plus a cargo config that sends every project's build output
# to one shared target directory.
{ config, pkgs, ... }:
{
  programs.cargo = {
    enable = true;
    # rustup provides cargo, and the rest of the toolchain with it --
    # rust-analyzer included -- so the module only writes the config.
    package = null;

    # With a target/ per project, every project compiles and stores its own
    # copy of each dependency, and those copies add up to many GB. With a
    # single target-dir, a crate built once at the same version, features and
    # profile is reused by every project. The tradeoffs: binaries end up in
    # ~/.cache/cargo/target/<profile>/ instead of ./target/<profile>/, two
    # cargo builds running at once wait on each other's lock, and `cargo
    # clean` empties the cache for every project. A project can opt out with
    # its own .cargo/config.toml, which takes precedence over this file.
    settings.build.target-dir = "${config.xdg.cacheHome}/cargo/target";

    # Debug info is the largest part of a debug build. Line tables are enough
    # for file:line in backtraces and panics; stepping through with a
    # debugger and inspecting variables needs full debug info. Profile
    # settings in a config file beat Cargo.toml, so ask for it with
    # CARGO_PROFILE_DEV_DEBUG=true, or with `[profile.dev] debug = true` in
    # the project's .cargo/config.toml.
    settings.profile.dev.debug = "line-tables-only";
  };

  home.packages = with pkgs; [
    rustup

    # The shared target-dir keeps every dependency version ever built, so it
    # only grows. `justg cargo-sweep` deletes what has not been used lately.
    cargo-sweep
  ];
}
