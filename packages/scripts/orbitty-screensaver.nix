{ pkgs }:
# Toggle wrapper for the orbitty terminal screensaver: launches a fullscreen
# ghostty running orbitty (any extra args are passed through to orbitty, e.g.
# `orbitty-screensaver -- --fps 60 --planet mars`). With --quit it only closes
# the screensaver window (used as hypridle on-resume).
pkgs.writeShellScriptBin "orbitty-screensaver" ''
  class="ghostty.orbitty"

  if [[ "''${1:-}" == "--quit" ]]; then
    hyprctl dispatch closewindow "class:^ghostty\.orbitty$" >/dev/null
    exit 0
  fi

  if hyprctl clients -j | jq -e --arg c "$class" 'any(.[]; .class == $c)' >/dev/null; then
    hyprctl dispatch closewindow "class:^ghostty\.orbitty$"
  else
    # orbitty refuses to start without 24-bit color; ghostty provides it, but
    # export explicitly so the check never fails under a bare env (hypridle).
    export COLORTERM="truecolor"
    ghostty --class="$class" --fullscreen=true -e orbitty "$@"
  fi
''
