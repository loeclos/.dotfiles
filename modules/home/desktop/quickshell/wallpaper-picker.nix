# modules/home/desktop/quickshell/wallpaper-picker.nix — Quickshell wallpaper picker (local images + video)
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awww
    mpvpaper
    # NOTE: no python3 — online Wallhaven search is intentionally unsupported
    # (upstream scripts/wallpaper_search.py + preview_pipeline.py never run;
    # Enter-in-search shows "Online search failed", local flow is unaffected).
    # quickshell, imagemagick (magick) and ffmpeg are already provided
    # via modules/nixos/apps/system.nix and modules/home/apps/user.nix.
  ];

  # Declarative wallpaper dir (also fixes the old undeployed ~/.config/wallpapers gap):
  # add wallpapers under assets/wallpaper/ (one-word names) and rebuild.
  # Read-only is fine — picker state/thumbs live in $XDG_CACHE_HOME/wallpaper_picker.
  xdg.configFile."wallpapers".source = ../../../../assets/wallpaper;

  # Launcher: pkgs/scripts/wallpaper-picker.nix (wired via apps/user.nix).
  # Syncs inputs.qs-wallpaper-picker to ~/.local/share, generates
  # config/Settings.qml, then runs the wrapped quickshell from
  # derivations/quickshell-multimedia.nix (stock quickshell lacks QtMultimedia).
  # Bound to SUPER+SHIFT+W (see hyprland/keybinds.nix); autostart runs
  # `wallpaper-picker --restore` after awww-daemon (restores last wallpaper,
  # else road.png).
}
