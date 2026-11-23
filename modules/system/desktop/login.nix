{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  security.pam.services.hyprlock = { };
}
