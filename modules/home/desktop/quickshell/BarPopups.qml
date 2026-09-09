// BarPopups.qml — smooth collapsible bar menus for wifi + bluetooth
// Waybar-style dropdowns anchored under the bar (top-right). Replaces the old
// centered Launcher wifi/bluetooth modes (replaces wifi-menu/bluetooth-menu scripts).
// Toggle: `quickshell ipc call popups toggle <wifi|bluetooth>` (empty = toggle current).
// Entrance (slide + fade, OutCubic) mirrors the Hyprland `smooth` bezier
// (cf. hyprland/settings.nix curve); only one menu is open at a time.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
  id: root
  property bool open: false
  property string mode: "wifi"
  property var items: []
  property string wifiRadio: ""
  property string btPowered: ""

  function toggle(m: string): void {
    if (root.open && (m === "" || m === root.mode)) {
      root.open = false;
    } else {
      if (m !== "") root.mode = m;
      root.open = true;
      root.refresh();
    }
  }

  function refresh(): void {
    if (root.mode === "wifi") { wifiRadioProc.running = true; wifiListProc.running = true; }
    else if (root.mode === "bluetooth") { btInfoProc.running = true; btListProc.running = true; }
  }

  // --- wifi backend (nmcli, moved from Launcher.qml) ---
  Process {
    id: wifiRadioProc
    command: ["sh", "-c", "nmcli -t -f WIFI general"]
    stdout: StdioCollector {
      onStreamFinished: { root.wifiRadio = text.trim(); }
    }
  }
  Process {
    id: wifiListProc
    command: ["sh", "-c", "nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE device wifi list --rescan no 2>/dev/null || nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE device wifi list"]
    stdout: StdioCollector {
      onStreamFinished: {
        const rows = text.trim().split("\n").filter(l => l.length > 0);
        root.items = rows.map(line => {
          const parts = line.split(":");
          const inUse = parts[parts.length - 1] === "*";
          const sec = parts.length >= 3 ? parts[parts.length - 2] : "";
          const sig = parts.length >= 3 ? parts[parts.length - 3] : "";
          const ssid = parts.slice(0, parts.length - 3).join(":") || "(hidden)";
          const e = { ssid: ssid };
          return {
            label: (inUse ? "* " : "") + ssid + "  " + sig + "%",
            sub: sec === "" ? "open" : sec,
            run: () => {
              Quickshell.execDetached(["sh", "-c", "nmcli device wifi connect \"" + e.ssid + "\" && notify-send 'WiFi' 'Connected to " + e.ssid + "' || notify-send -u critical 'WiFi' 'Failed to connect to " + e.ssid + "'"]);
              root.open = false;
            }
          };
        });
      }
    }
  }

  // --- bluetooth backend (bluetoothctl, moved from Launcher.qml) ---
  Process {
    id: btInfoProc
    command: ["sh", "-c", "bluetoothctl show 2>/dev/null | grep 'Powered:' | awk '{print $2}'"]
    stdout: StdioCollector {
      onStreamFinished: { root.btPowered = text.trim(); }
    }
  }
  Process {
    id: btListProc
    command: ["sh", "-c", "connected=$(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}'); bluetoothctl devices 2>/dev/null | while read -r _ mac rest; do if echo \"$connected\" | grep -q \"$mac\"; then echo \"* $mac $rest\"; else echo \"  $mac $rest\"; fi; done"]
    stdout: StdioCollector {
      onStreamFinished: {
        const rows = text.trim().split("\n").filter(l => l.length > 0);
        root.items = rows.map(line => {
          const connected = line.startsWith("*");
          const mac = line.slice(2).split(" ")[0];
          const name = line.slice(2 + mac.length + 1) || mac;
          const e = { mac: mac, connected: connected };
          return {
            label: (connected ? "* " : "") + name,
            sub: mac,
            run: () => {
              const act = e.connected ? "disconnect" : "connect";
              Quickshell.execDetached(["sh", "-c", "bluetoothctl " + act + " " + e.mac]);
              root.open = false;
            }
          };
        });
      }
    }
  }

  IpcHandler {
    target: "popups"
    function toggle(mode: string): void { root.toggle(mode); }
  }

  Variants {
    model: Quickshell.screens
    PanelWindow {
      id: window
      required property var modelData
      screen: modelData
      // Stay visible through the fade-out so the close animates instead of popping.
      visible: root.open || card.opacity > 0
      color: "transparent"
      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }
      exclusionMode: ExclusionMode.Ignore
      HyprlandFocusGrab {
        windows: [window]
        active: root.open
      }
      Item {
        focus: root.open
        Keys.onPressed: e => {
          if (e.key === Qt.Key_Escape) root.open = false;
        }
      }
      MouseArea {
        anchors.fill: parent
        onClicked: root.open = false
      }
      Rectangle {
        id: card
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 36
        anchors.rightMargin: 8
        implicitWidth: Theme.popupWidth
        implicitHeight: 332
        radius: Theme.radius
        color: Theme.palette.bg0
        border.color: Theme.palette.surface
        border.width: 1
        opacity: root.open ? 1 : 0
        Behavior on opacity {
          NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic }
        }
        transform: Translate {
          y: root.open ? 0 : -8
          Behavior on y {
            NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic }
          }
        }
        MouseArea {
          anchors.fill: parent
          onClicked: mouse => mouse.accepted = true
        }
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 8
          spacing: 6
          Rectangle {
            Layout.fillWidth: true
            implicitHeight: 28
            color: "transparent"
            RowLayout {
              anchors.fill: parent
              spacing: 8
              Text {
                text: root.mode === "wifi" ? "WiFi" : "Bluetooth"
                color: Theme.palette.fg
                font.family: Theme.sans
                font.pixelSize: Theme.size
                font.bold: true
              }
              Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                text: root.mode === "wifi" ? ("[" + root.wifiRadio + "] rescan") : ("[" + root.btPowered + "] scan")
                color: Theme.palette.muted
                font.family: Theme.sans
                font.pixelSize: Theme.sizeSmall
                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  onEntered: parent.color = Theme.palette.fg
                  onExited: parent.color = Theme.palette.muted
                  onClicked: {
                    if (root.mode === "wifi") Quickshell.execDetached(["sh", "-c", "nmcli device wifi rescan; sleep 3; quickshell ipc call popups toggle wifi; quickshell ipc call popups toggle wifi"]);
                    else Quickshell.execDetached(["sh", "-c", "bluetoothctl --timeout 8 scan on >/dev/null 2>&1; quickshell ipc call popups toggle bluetooth; quickshell ipc call popups toggle bluetooth"]);
                  }
                }
              }
            }
          }
          Text {
            visible: root.items.length === 0
            Layout.fillWidth: true
            text: "Scanning…"
            color: Theme.palette.muted
            font.family: Theme.sans
            font.pixelSize: Theme.sizeSmall
          }
          ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.items
            highlight: Rectangle { color: Theme.palette.surface; radius: Theme.radiusSmall }
            highlightMoveDuration: Theme.animFast
            add: Transition {
              NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.animFast; easing.type: Easing.OutCubic }
              NumberAnimation { property: "x"; from: 12; to: 0; duration: Theme.animFast; easing.type: Easing.OutCubic }
            }
            displaced: Transition {
              NumberAnimation { properties: "x,y"; duration: Theme.animFast; easing.type: Easing.OutCubic }
            }
            delegate: Rectangle {
              required property var modelData
              required property int index
              width: list.width
              implicitHeight: 32
              radius: Theme.radiusSmall
              color: list.currentIndex === index ? Theme.palette.surface : "transparent"
              Behavior on color {
                ColorAnimation { duration: Theme.animFast }
              }
              Text {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                verticalAlignment: Text.AlignVCenter
                text: modelData.label + (modelData.sub !== "" ? "  ·  " + modelData.sub : "")
                elide: Text.ElideRight
                color: Theme.palette.fgAlt
                font.family: Theme.sans
                font.pixelSize: Theme.size
              }
              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: list.currentIndex = index
                onClicked: modelData.run()
              }
            }
          }
        }
      }
    }
  }
}
