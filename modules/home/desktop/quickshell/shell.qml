// shell.qml — entry point: bar + notifications + launcher/powermenu + bar popups
// Layout mirrors waybar.nix modules-left/center/right; styling mirrors style.css.
import QtQuick
import Quickshell

ShellRoot {
  Bar {}
  Notifications {}
  Launcher {}
  BarPopups {}
}
