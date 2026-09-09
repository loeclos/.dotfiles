// Separator.qml — the waybar custom/separator module ("|", dim gray)
import QtQuick

Text {
  text: "|"
  color: Theme.palette.gray
  opacity: 0.35
  font.family: Theme.barFont
  font.pixelSize: Theme.size
  font.bold: true
}
