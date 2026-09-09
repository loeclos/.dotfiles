// Clock.qml — {:%d/%m - %H:%M} in bright-yellow (cf. waybar clock)
import QtQuick
import Quickshell

Text {
  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
  text: Qt.formatDateTime(clock.date, "dd/MM - HH:mm")
  color: Theme.palette.brightYellow
  font.family: Theme.barFont
  font.pixelSize: Theme.size
  font.bold: true
}
