// Workspaces.qml — persistent workspaces 1-9 (cf. waybar.nix persistent-workspaces)
// Active ws: bright-yellow bg + dark text; empty ws dimmed (cf. style.css #workspaces).
import QtQuick
import Quickshell.Hyprland

Row {
  spacing: 4
  Repeater {
    model: 9
    Rectangle {
      required property int index
      property string wsName: String(index + 1)
      property var ws: Hyprland.workspaces.values.find(w => w.name === wsName) ?? null
      property bool isActive: (Hyprland.focusedWorkspace?.name ?? "") === wsName
      width: 17
      height: 24
      radius: 3
      color: isActive ? Theme.palette.brightYellow : "transparent"
      Behavior on color {
        ColorAnimation { duration: Theme.animFast }
      }
      opacity: (ws == null && !isActive) ? 0.45 : 1.0
      Behavior on opacity {
        NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic }
      }
      Text {
        anchors.centerIn: parent
        text: wsName
        color: isActive ? Theme.palette.bg : Theme.palette.fg
        font.family: Theme.barFont
        font.pixelSize: Theme.size
        font.bold: true
      }
      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("workspace " + wsName)
      }
    }
  }
}
