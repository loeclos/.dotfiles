{ pkgs }:
pkgs.writeShellScriptBin "power-profile-cycle" ''
  powerprofilesctl=${pkgs.power-profiles-daemon}/bin/powerprofilesctl
  profiles_output="$($powerprofilesctl list)"
  current="$($powerprofilesctl get)"
  profiles=()

  # Keep a predictable saver → balanced → performance cycle, skipping modes
  # that the laptop's hardware/firmware does not advertise.
  for profile in power-saver balanced performance; do
    if printf '%s\n' "$profiles_output" | ${pkgs.gnugrep}/bin/grep -Eq "^[[:space:]]*[*]?[[:space:]]*''${profile}:"; then
      profiles+=("$profile")
    fi
  done

  if (( ''${#profiles[@]} == 0 )); then
    echo "powerprofilesctl reported no supported profiles" >&2
    exit 1
  fi

  next="''${profiles[0]}"
  for i in "''${!profiles[@]}"; do
    if [[ "''${profiles[$i]}" == "$current" ]]; then
      next="''${profiles[$(((i + 1) % ''${#profiles[@]}))]}"
      break
    fi
  done

  "$powerprofilesctl" set "$next"
  ${pkgs.libnotify}/bin/notify-send "Power profile" "$next"
''
