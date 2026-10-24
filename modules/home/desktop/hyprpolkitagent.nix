# modules/home/desktop/hyprpolkitagent.nix — polkit auth agent for Hyprland/UWSM
# Provides the GUI password prompt for pkexec (agents prefix privileged commands with pkexec).
# HM user service (wanted by graphical-session.target, which UWSM owns) —
# don't launch via hyprland/autostart.nix: the binary lives in libexec, not bin/.
#
# Styling is two layers (hyprtoolkit agent, v0.2.0+ minimal patch, see
# packages/builds/hyprpolkitagent-dialog.cpp):
# - hypr/hyprtoolkit.conf — Gruvbox palette + fonts, derived from lib/theme.nix.
#   background is transparent (the patched dialog draws a single translucent
#   dark card behind Allow:+input instead of an opaque window, so the white
#   letters stay readable on any wallpaper); base/alternate_base stay opaque
#   so the password field itself remains visible.
# - hyprpolkitagent/hyprpolkitagent.conf — minimal floating prompt size.
#   show_details is kept false (the patched build has no details panel at all).
# Placement/chrome (float, center, borderless, dimmed surroundings,
# no blur/shadow) is a window rule in desktop/hyprland/window-rules.nix
# matching the dialog class.
# Enter submits, Escape cancels — there are no buttons by design.
{ theme, ... }:
let
  mkArgb = hex: "0xFF${theme.mkRgb hex}";
in
{
  services.hyprpolkitagent.enable = true;

  xdg.configFile = {
    "hypr/hyprtoolkit.conf".text = ''
      background = 0x00000000
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
        window_width = 420
        window_height = 160
        show_details = false
      }
    '';
  };
}
