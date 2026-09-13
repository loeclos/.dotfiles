# login/hyprlock.nix — PAM auth for the hyprlock session lock.
# home-manager's programs.hyprlock installs the binary + config but cannot
# authenticate without a NixOS PAM service, so declare it here.
{ ... }:
{
  security.pam.services.hyprlock = { };
}
