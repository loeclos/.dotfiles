{ pkgs }:
pkgs.writeShellScriptBin "hypr-float-toggle" ''
  #!/usr/bin/env bash
  class="$1"
  shift
  if hyprctl clients -j | jq -e --arg c "$class" 'any(.[]; .class == $c)' >/dev/null; then
    hyprctl dispatch "hl.dsp.window.close({window = 'class:$class'})"
  else
    ghostty --class="$class" -e "$@"
  fi
''
