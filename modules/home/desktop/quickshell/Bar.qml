// Bar.qml — top bar mirroring waybar layout and style.css
// left: workspaces + separator | STRICT center: mpris | right: tray + sep + net/bt/audio/stats/battery + sep + clock
// (left/right are edge-anchored and mpris is parent-centered, so it stays
// truly centered regardless of side widths; capped at 40% width with elide.)
// Toggle at runtime: `quickshell ipc call bar toggle` (cf. SUPER+SHIFT+SPACE waybar toggle).
import QtQuick
import Quickshell
import Quickshell.Io

Scope {
  id: root
  property bool visible: true

  IpcHandler {
    target: "bar"
    function toggle(): void { root.visible = !root.visible; }
  }

  Variants {
    model: Quickshell.screens
    PanelWindow {
      required property var modelData
      screen: modelData
      visible: root.visible
      color: "transparent"
      anchors {
        top: true
        left: true
        right: true
      }
      implicitHeight: 30
      Rectangle {
        id: bg
        anchors.fill: parent
        color: Theme.palette.bg
        Rectangle {
          anchors.bottom: parent.bottom
          width: parent.width
          height: 1
          color: Theme.palette.fg
          opacity: 0.1
        }
        Row {
          anchors {
            left: parent.left
            leftMargin: 8
            verticalCenter: parent.verticalCenter
          }
          spacing: 8
          Workspaces {}
          Separator {}
        }
        Item {
          anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
          }
          width: Math.min(parent.width * 0.4, centerText.implicitWidth)
          height: parent.height
          clip: true
          Mpris {
            id: centerText
            anchors.centerIn: parent
            width: Math.min(parent.width, implicitWidth)
            elide: Text.ElideRight
          }
        }
        Row {
          anchors {
            right: parent.right
            rightMargin: 8
            verticalCenter: parent.verticalCenter
          }
          spacing: 8
          Tray {}
          Separator {}
          NetBt {}
          Audio {}
          SysStats {}
          Battery {}
          Separator {}
          Clock {}
        }
      }
    }
  }
}
