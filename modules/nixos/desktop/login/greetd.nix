# greetd.nix — NixOS system module for greetd + tuigreet (TTY login)
# TTY-based greeter for the Hyprland session (launched via UWSM, see
# ../hyprland.nix `withUWSM`). Replaces the SDDM graphical greeter:
# no Qt theme, no cursor/font wiring — just a terminal prompt on TTY1.
# Session lock is NOT handled here — see ./hyprlock.nix (PAM for hyprlock).
{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd \"uwsm start hyprland-uwsm.desktop\"";
        user = "greeter";
      };
    };
  };
}
