// Audio.qml — pamixer volume (cf. waybar pulseaudio + F2/F3 keybinds)
// Native Pipewire bindings left the default sink unbound (mute-toggle errors),
// so this polls pamixer like the rest of the system: scroll = step, click = mute.
import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  implicitWidth: row.width
  implicitHeight: row.height
  property bool muted: true
  property int level: 0

  Row {
    id: row
    spacing: 4
    Text {
      text: root.muted ? Theme.icons.muted : Theme.icons.volume
      color: Theme.palette.fg
      font.family: Theme.barFont
      font.pixelSize: Theme.size
      font.bold: true
    }
    Text {
      text: root.muted ? "" : root.level + "%"
      visible: !root.muted
      color: Theme.palette.fg
      font.family: Theme.barFont
      font.pixelSize: Theme.size
      font.bold: true
    }
  }
  Timer {
    running: true
    repeat: true
    interval: 2000
    triggeredOnStart: true
    onTriggered: volProc.running = true
  }
  Process {
    id: volProc
    command: ["sh", "-c", "pamixer --get-volume-human"]
    stdout: StdioCollector {
      onStreamFinished: {
        const out = text.trim();
        root.muted = out === "muted";
        if (!root.muted) root.level = parseInt(out.replace("%", "")) || 0;
      }
    }
  }
  MouseArea {
    anchors.fill: parent
    onWheel: e => {
      Quickshell.execDetached(["sh", "-c", e.angleDelta.y > 0 ? "pamixer -i 5" : "pamixer -d 5"]);
      volProc.running = true;
    }
    onClicked: {
      Quickshell.execDetached(["sh", "-c", "pamixer -t"]);
      volProc.running = true;
    }
  }
}
