# modules/system/desktop/login.nix — TTY greeter + session-lock auth.
# Two small pieces, one purpose (logging in / staying locked):
#
# - greetd + tuigreet: TTY-based greeter for the Hyprland session (launched
#   via UWSM, see ./hyprland.nix `withUWSM`). Replaces the SDDM graphical
#   greeter: no Qt theme, no cursor/font wiring — just a terminal prompt on TTY1.
# - hyprlock PAM: home-manager's programs.hyprlock installs the binary +
#   config but cannot authenticate without a NixOS PAM service, so declare it here.
{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Absolute uwsm path: greeter user has minimal PATH.
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd \"/run/current-system/sw/bin/uwsm start hyprland-uwsm.desktop &> /dev/null\"";
        user = "greeter";
      };
    };
  };

  security.pam.services.hyprlock = { };
}
