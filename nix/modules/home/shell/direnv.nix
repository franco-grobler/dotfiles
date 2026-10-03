# direnv, driven by direnv-instant instead of its stock shell hooks.
#
# A tmuxinator project opens every pane at once, and with a cold nix-direnv
# cache each one used to evaluate the same flake in parallel -- fighting over the
# eval-cache sqlite db and each fetching the whole closure, with every prompt
# frozen until its own copy finished. direnv-instant runs one background daemon
# per .envrc: the first shell starts it, later shells only ask to be signalled,
# and every prompt comes back immediately. A load slower than `mux_delay` opens
# a tmux split with direnv's output, which is also where ^C goes.
#
# Its module turns off programs.direnv's shell integrations itself; direnv and
# nix-direnv stay installed underneath it.
{ inputs, ... }:
{
  imports = [ inputs.direnv-instant.homeModules.direnv-instant ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.direnv-instant = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
