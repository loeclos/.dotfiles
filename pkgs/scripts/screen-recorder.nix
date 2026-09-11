{ pkgs }:
pkgs.writeShellScriptBin "screen-recorder" ''
  #!/usr/bin/env bash
  # Toggle wl-screenrec: region via slurp, saves to ~/Videos/Screenrecordings.
  set -euo pipefail

  OUT_DIR="$HOME/Videos/Screenrecordings"
  mkdir -p "$OUT_DIR"

  if pgrep -x wl-screenrec >/dev/null 2>&1; then
    pkill -INT -x wl-screenrec
    notify-send "Screen recording" "Recording stopped — saved to $OUT_DIR" || true
    exit 0
  fi

  FILE="$OUT_DIR/$(date +%Y-%m-%d_%H-%M-%S).mp4"

  ARGS=()
  if [ "''${1:-}" = "--audio" ]; then
    ARGS+=(--audio)
  fi

  if [ "''${1:-}" = "--fullscreen" ]; then
    notify-send "Screen recording" "Recording fullscreen…" || true
    # shellcheck disable=SC2086
    exec wl-screenrec "''${ARGS[@]}" -f "$FILE"
  fi

  # Default: region select via slurp; cancel aborts without recording.
  GEO="$(slurp)" || exit 0
  notify-send "Screen recording" "Recording region… (SUPER+R to stop)" || true
  # shellcheck disable=SC2086
  exec wl-screenrec "''${ARGS[@]}" -g "$GEO" -f "$FILE"
''
