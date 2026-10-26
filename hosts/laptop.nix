# hosts/laptop.nix — laptop host: identity + hardware.
# Shared system config comes from modules/system (auto-imported, see
# modules/system/default.nix); shared host basics (timezone, locale, user)
# from ./common.nix. Wired by lib/mkHost.nix.
{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware/laptop.nix
    ../modules/system
  ];

  networking.hostName = "laptop";

  services.power-profiles-daemon.enable = true;
}
