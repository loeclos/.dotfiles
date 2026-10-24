{ pkgs }:
pkgs.writeShellScriptBin "usb-sound" ''
  # usb-sound <sound-file> — play a short effect on every active user session.
  # Called from the udev add/remove rules (see modules/system/hardware/usb-sound.nix),
  # which run as root without PipeWire access — so fan out to each /run/user/<uid>
  # via runuser with that session's XDG_RUNTIME_DIR/DBus address, backgrounded
  # so udev never blocks.
  sound="$1"
  [ -n "$sound" ] || exit 1
  [ -f "$sound" ] || exit 1

  for d in /run/user/*; do
    [ -d "$d" ] || continue
    uid=$(basename "$d")
    case "$uid" in *[!0-9]*) continue ;; esac
    [ "$uid" -ge 1000 ] 2>/dev/null || continue
    user=$(${pkgs.coreutils}/bin/id -nu "$uid" 2>/dev/null) || continue
    XDG_RUNTIME_DIR="$d" DBUS_SESSION_BUS_ADDRESS="unix:path=$d/bus" \
      ${pkgs.util-linux}/bin/runuser -u "$user" -- \
      ${pkgs.mpv}/bin/mpv --no-video --no-terminal --really-quiet "$sound" &
  done
  exit 0
''
