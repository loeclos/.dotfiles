{ pkgs }:
pkgs.writeShellScriptBin "hypr-float-toggle" ''
  #!/usr/bin/env bash
  class="$1"
  shift
  if hyprctl clients -j | jq -e --arg c "$class" 'any(.[]; .class == $c)' >/dev/null; then
    hyprctl dispatch closewindow "class:^$(printf '%s' "$class" | sed 's/\./\\./g')$"
  else
    ghostty --class="$class" -e "$@"
  fi
''
