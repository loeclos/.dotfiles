# modules/home/desktop/hyprpolkitagent.nix — polkit auth agent for Hyprland/UWSM
# Provides the GUI password prompt for pkexec (agents prefix privileged commands with pkexec).
# HM user service (wanted by graphical-session.target, which UWSM owns) —
# don't launch via hyprland/autostart.nix: the binary lives in libexec, not bin/.
#
# Styling is two layers (hyprtoolkit agent, v0.2.0+):
# - hypr/hyprtoolkit.conf — Gruvbox palette + fonts, derived from lib/theme.nix
# - hyprpolkitagent/hyprpolkitagent.conf — compact single-prompt dialog, no details panel
#   (flip show_details to true to see the action/command being authorized)
# Placement/chrome (float, center, borderless, dimmed background) is a
# window rule in desktop/hyprland/window-rules.nix matching the dialog title.
{ theme, ... }:
let
  mkArgb = hex: "0xFF${theme.mkRgb hex}";
in
{
  services.hyprpolkitagent.enable = true;

  xdg.configFile = {
    "hypr/hyprtoolkit.conf".text = ''
      background = ${mkArgb theme.palette.bg0}
      base = ${mkArgb theme.palette.bg}
      text = ${mkArgb theme.palette.fg}
      alternate_base = ${mkArgb theme.palette.surface}
      bright_text = ${mkArgb theme.palette.fgAlt}
      accent = ${mkArgb theme.palette.brightYellow}
      accent_secondary = ${mkArgb theme.palette.brightAqua}
      font_family = "${theme.fonts.sans}"
      font_family_monospace = "${theme.fonts.mono}"
      rounding_large = 12
      rounding_small = 8
    '';

    "hyprpolkitagent/hyprpolkitagent.conf".text = ''
      general {
        password_field_width = 340
        window_width = 460
        window_height = 300
        show_details = false
      }
    '';
  };
}
