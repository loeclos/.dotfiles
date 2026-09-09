// Notifications.qml — NotificationServer panel (cf. dunst.nix: 550px, top-right, 20px offset, limit 5)
// Urgency colors/timeouts mirror dunst: low 4s / normal 10s / critical sticky.
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Scope {
  id: root
  NotificationServer {
    id: server
    actionsSupported: true
    bodySupported: true
    onNotification: n => { n.tracked = true; }
  }
  Variants {
    model: Quickshell.screens
    PanelWindow {
      required property var modelData
      screen: modelData
      color: "transparent"
      anchors {
        top: true
        right: true
      }
      implicitWidth: 550
      implicitHeight: 500
      Column {
        spacing: 6
        Repeater {
          model: server.trackedNotifications.values.slice(0, 5)
          Rectangle {
            required property var modelData
            property bool critical: modelData.urgency === NotificationUrgency.Critical
            property bool low: modelData.urgency === NotificationUrgency.Low
            width: 550
            implicitHeight: 60
            radius: Theme.radiusSmall
            color: critical ? Theme.palette.bg : Theme.palette.bg
            border.color: critical ? Theme.palette.brightRed : Theme.palette.border
            border.width: 1
            opacity: 0
            NumberAnimation on opacity {
              from: 0
              to: 1
              duration: Theme.animMed
              easing.type: Easing.OutCubic
            }
            Timer {
              running: true
              repeat: false
              interval: parent.critical ? 3600000 : (parent.low ? 4000 : 10000)
              onTriggered: modelData.dismiss()
            }
            Text {
              anchors.fill: parent
              anchors.margins: 10
              text: "<b>" + modelData.summary + "</b><br>" + modelData.body
              textFormat: Text.RichText
              color: critical ? Theme.palette.brightRed : (low ? Theme.palette.gray : Theme.palette.fgAlt)
              font.family: Theme.sans
              font.pixelSize: Theme.sizeSmall
              wrapMode: Text.Wrap
              elide: Text.ElideMiddle
            }
            MouseArea {
              anchors.fill: parent
              onClicked: modelData.dismiss()
            }
          }
        }
      }
    }
  }
}
