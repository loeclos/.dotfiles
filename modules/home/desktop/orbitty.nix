# modules/home/desktop/orbitty.nix — orbitty terminal screensaver.
# orbitty itself is flag-only (no config file); defaults (fps 30, earth) are
# fine, pass through the wrapper for more: `orbitty-screensaver -- --planet mars`.
# Lifecycle lives in hypridle.nix (on-timeout launches, on-resume --quit) and
# SUPER+S in desktop/hyprland/keybinds.nix (toggle); fullscreen is forced by
# the ghostty.orbitty rule in desktop/hyprland/window-rules.nix.
{ pkgs, ... }:
{
  home.packages = [
    pkgs.orbitty
    pkgs.orbitty-screensaver
  ];
}
