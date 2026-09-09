// Mpris.qml — now-playing, max 50 chars, click toggles play/pause (cf. waybar mpris)
import QtQuick
import Quickshell.Services.Mpris

Text {
  property var player: Mpris.players.values[0] ?? null
  text: player ? (Theme.icons.music + " " + (player.trackArtist + " - " + player.trackTitle)).slice(0, 50) : ""
  visible: player != null
  color: Theme.palette.brightAqua
  font.family: Theme.barFont
  font.pixelSize: Theme.size
  font.bold: true
  MouseArea {
    anchors.fill: parent
    onClicked: { if (player) player.togglePlaying(); }
  }
}
