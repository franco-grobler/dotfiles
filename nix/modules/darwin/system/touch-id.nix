# sudo via Touch ID / Apple Watch, surviving tmux re-attach.
{
  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };
}
