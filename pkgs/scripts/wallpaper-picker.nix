{
  pkgs,
  appSrc,
  quickshellBin,
}:
pkgs.writeShellScriptBin "wallpaper-picker" ''
  set -euo pipefail

  APP_SRC="${appSrc}"
  DEST="$HOME/.local/share/wallpaper-picker"
  # ~/.config/wallpapers is a symlink to the nix store (see quickshell module).
  # Resolve it: find(1) -maxdepth (used by upstream sync_thumbs.sh) does not
  # traverse a symlinked starting point, which silently yields zero thumbnails.
  WALLPAPER_DIR="$(readlink -f "$HOME/.config/wallpapers")"
  STATE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper_picker"

  # The nix store copy is read-only and lacks config/Settings.qml (gitignored
  # upstream), which WallpaperPicker.qml imports — so sync to a writable copy
  # and generate Settings.qml there on every run (cheap, keeps lock updates fresh).
  # Wrapped quickshell (derivations/quickshell-multimedia.nix) — stock nixpkgs
  # quickshell lacks the QtMultimedia QML modules the picker imports.
  QUICKSHELL="${quickshellBin}"

  sync_app() {
    rm -rf "$DEST"
    cp -r "$APP_SRC" "$DEST"
    chmod -R u+w "$DEST"
    cat > "$DEST/config/Settings.qml" <<'SETTINGS_EOF'
  import QtQuick
  import Quickshell

  QtObject {
      readonly property string homeDir: Quickshell.env("HOME")
      readonly property string configuredWallpaperDir: Quickshell.env("QS_WALLPAPER_DIR")
      readonly property string configuredCacheHome: Quickshell.env("XDG_CACHE_HOME")

      property string wallpaperDir: configuredWallpaperDir !== "" ? configuredWallpaperDir : homeDir + "/.config/wallpapers"
      readonly property string cacheHome: configuredCacheHome !== "" ? configuredCacheHome : homeDir + "/.cache"
      readonly property string cacheDir: cacheHome + "/wallpaper_picker"
      readonly property string thumbDir: cacheDir + "/thumbs"

      property bool uiAnimationsEnabled: true
      property real uiAnimationScale: 1.0

      property string wallpaperTransitionType: "random"
      property real wallpaperTransitionDuration: 0.6
      property int wallpaperTransitionFps: 60

      property int closeDelayMs: 120
      property int scrollThrottleMs: 150

      // All dynamic-theming integrations stay off on purpose:
      // lib/theme.nix is the single source of truth for colors.
      property bool enableDynamicColors: false
      property bool enableMatugen: false
      property bool enableHyprReload: false
      property bool enableWaybarReload: false
      property bool enableKittyReload: false
      property bool enableCavaReload: false
      property bool enableSwayncReload: false
      property bool enableSwayosdReload: false

      property string hyprColorsPath: homeDir + "/.config/hypr/colors.conf"
      property string waybarColorsPath: homeDir + "/.config/waybar/colors.css"
      property string waybarLaunchPath: homeDir + "/.config/waybar/launch.sh"
      property string kittySignalProcess: ".kitty-wrapped"

      property string extraReloadCommand: ""
  }
  SETTINGS_EOF
  }

  # awww img fails while awww-daemon is still starting (autostart race) — retry briefly.
  awww_img() {
    i=0
    until awww img --transition-type fade --transition-duration 0.4 "$1" >/dev/null 2>&1; do
      i=$((i + 1))
      [ "$i" -ge 20 ] && return 1
      sleep 0.5
    done
  }

  cmd_restore() {
    sync_app
    export QS_WALLPAPER_DIR="$WALLPAPER_DIR"
    export QS_WALLPAPER_ENABLE_ML4W=0
    if [ -f "$STATE_DIR/last_wallpaper" ]; then
      bash "$DEST/scripts/restore_wallpaper.sh" || true
    else
      awww_img "$WALLPAPER_DIR/road.png" || true
    fi
  }

  cmd_open() {
    sync_app
    export QS_WALLPAPER_DIR="$WALLPAPER_DIR"
    export QS_WALLPAPER_ENABLE_ML4W=0
    # shellcheck disable=SC1090
    source "$DEST/scripts/cache_paths.sh"
    ensure_wallpaper_cache_compatibility
    # NOTE: WALLPAPER_DIR is home-manager-deployed (see quickshell module) —
    # only the cache dir is created here.
    mkdir -p "$STATE_DIR" "$STATE_DIR/thumbs"
    # Fast launch: thumbnail sync runs in the background (picker's
    # FolderListModel picks up new thumbnails live), so the UI opens instantly.
    if command -v nice >/dev/null 2>&1; then
      nice -n 19 bash "$DEST/scripts/sync_thumbs.sh" "$WALLPAPER_DIR" \
        >"$STATE_DIR/sync_thumbs.log" 2>&1 &
    else
      bash "$DEST/scripts/sync_thumbs.sh" "$WALLPAPER_DIR" \
        >"$STATE_DIR/sync_thumbs.log" 2>&1 &
    fi
    disown 2>/dev/null || true
  if command -v flock >/dev/null 2>&1; then
    exec flock -n -o "$STATE_DIR/picker.lock" "$QUICKSHELL" -p "$DEST/Main.qml"
  fi
  exec "$QUICKSHELL" -p "$DEST/Main.qml"
  }

  case "''${1:-}" in
    --restore) cmd_restore ;;
    "") cmd_open ;;
    *)
      echo "usage: wallpaper-picker [--restore]" >&2
      exit 2
      ;;
  esac
''
