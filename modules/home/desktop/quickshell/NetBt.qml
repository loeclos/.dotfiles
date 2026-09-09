// NetBt.qml — network + bluetooth status icons (cf. waybar network/bluetooth)
// Left-click opens the BarPopups wifi/bluetooth dropdowns (replaces wifi-menu/bluetooth-menu scripts);
// right-click toggles the radio (cf. on-click-right in waybar.nix).
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Bluetooth

Row {
  spacing: 8
  Process {
    id: radioToggle
    property var args: []
    command: ["sh", "-c", radioToggle.args.join(" ")]
  }
  Text {
    id: netIcon
    property string netName: Networking.primary?.name ?? ""
    // NMDeviceState: 0 unknown, 10 unmanaged, 20 unavailable, 30 disconnected,
    // 40+ (prepare/config/ip/activated=100) = link coming up or up.
    property bool linkUp: (Networking.primary?.state ?? 0) >= 40
    property bool isWifi: (Networking.primary?.type ?? -1) === 2 /* DeviceType.Wifi */
    text: netName === "" ? Theme.icons.ethernet : ((linkUp && isWifi) ? Theme.icons.wifi : Theme.icons.ethernet)
    color: netName === "" ? Theme.palette.gray : Theme.palette.fg
    font.family: Theme.barFont
    font.pixelSize: Theme.size
    font.bold: true
    opacity: netHovered.hovered ? 1.0 : 0.8
    Behavior on opacity {
      NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic }
    }
    MouseArea {
      id: netHovered
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) Quickshell.execDetached(["quickshell", "ipc", "call", "popups", "toggle", "wifi"]);
        else { radioToggle.args = ["nmcli radio wifi toggle"]; radioToggle.running = true; }
      }
    }
  }
  Text {
    id: btIcon
    property var adapter: Bluetooth.defaultAdapter
    text: (adapter?.enabled ?? false) ? Theme.icons.bluetoothOn : Theme.icons.bluetoothOff
    color: (adapter?.enabled ?? false) ? Theme.palette.brightBlue : Theme.palette.fg
    font.family: Theme.barFont
    font.pixelSize: Theme.size
    font.bold: true
    opacity: btHovered.hovered ? 1.0 : 0.8
    Behavior on opacity {
      NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic }
    }
    MouseArea {
      id: btHovered
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) Quickshell.execDetached(["quickshell", "ipc", "call", "popups", "toggle", "bluetooth"]);
        else { radioToggle.args = ["bluetoothctl power toggle"]; radioToggle.running = true; }
      }
    }
  }
}
