// Tray.qml — expandable tray (cf. waybar group/tray-expander + custom/expand-icon)
// Collapse animates width + fade (OutCubic, like the Hyprland `smooth` curve)
// instead of popping icons in/out.
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Row {
  id: root
  spacing: 8
  property bool expanded: true
  Text {
    text: root.expanded ? Theme.icons.expanded : Theme.icons.collapsed
    color: Theme.palette.gray
    opacity: 0.4
    font.family: Theme.barFont
    font.pixelSize: 10
    rotation: root.expanded ? 0 : -90
    Behavior on rotation {
      NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic }
    }
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: parent.opacity = 1.0
      onExited: parent.opacity = 0.4
      onClicked: root.expanded = !root.expanded
    }
    Behavior on opacity {
      NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic }
    }
  }
  Item {
    id: clip
    clip: true
    width: root.expanded ? trayRow.width : 0
    height: trayRow.height
    opacity: root.expanded ? 1 : 0
    Behavior on width {
      NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic }
    }
    Behavior on opacity {
      NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic }
    }
    Row {
      id: trayRow
      spacing: 8
      Repeater {
        model: SystemTray.items
        IconImage {
          required property var modelData
          source: modelData.icon
          implicitSize: 16
          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: mouse => {
              if (mouse.button === Qt.LeftButton && modelData.activate) modelData.activate();
              else if (modelData.secondaryActivate) modelData.secondaryActivate();
            }
          }
        }
      }
    }
  }
}
