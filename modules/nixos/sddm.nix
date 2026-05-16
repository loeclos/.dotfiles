# sddm.nix — NixOS system module for SDDM + sddm-astronaut-theme (pixel_sakura variant)
# Target: NixOS unstable / 25.11 with flake-based configuration
# Import from flake.nix or configuration.nix:
#   imports = [ ./sddm.nix ];
{ pkgs, lib, ... }:

let
  # Build the theme package with the pixel_sakura animated variant selected.
  # The nixpkgs sddm-astronaut package rewrites metadata.desktop's ConfigFile
  # to point at Themes/<embeddedTheme>.conf at build time.
  sddm-astronaut-pixel-sakura = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  # ── Display-manager / SDDM ────────────────────────────────────────────────

  services.displayManager.sddm = {
    enable = true;

    # Explicitly use the Qt 6 build of SDDM (required by the theme).
    package = pkgs.kdePackages.sddm;

    # Register the theme by the name SDDM discovers under /share/sddm/themes/.
    theme = "sddm-astronaut-theme";

    # Wayland greeter — remove or set to false if you only use X11.
    wayland.enable = true;

    # Qt/QML packages that the greeter process must be able to load at runtime,
    # plus the theme package itself so its share/ tree is on the search path.
    #   kdePackages.qtmultimedia    → animated wallpaper (pixel_sakura needs this)
    #   kdePackages.qtsvg           → SVG rendering used throughout the theme
    #   kdePackages.qtvirtualkeyboard → on-screen keyboard
    extraPackages = with pkgs.kdePackages; [
      sddm-astronaut-pixel-sakura
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
    ];

    # Enable the virtual keyboard in SDDM's greeter.
    settings = {
      General = {
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };

  # ── Theme package ─────────────────────────────────────────────────────────
  # Also expose the theme in systemPackages so its path is linked under
  # /run/current-system/sw (required for SDDM to discover the theme directory).
  environment.systemPackages = [
    sddm-astronaut-pixel-sakura
  ];

  # ── Fonts shipped with the theme ──────────────────────────────────────────
  # The theme bundles custom bitmap/pixel fonts; make them available system-wide
  # so they render correctly inside the greeter.
  fonts.packages = [
    sddm-astronaut-pixel-sakura
  ];
}
