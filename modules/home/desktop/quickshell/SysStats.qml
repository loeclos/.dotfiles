// SysStats.qml — CPU/MEM polling (cf. waybar cpu interval 10s / memory interval 2s)
import QtQuick
import Quickshell.Io

Row {
  spacing: 8
  Text {
    id: cpu
    text: "CPU --%"
    color: Theme.palette.fg
    font.family: Theme.barFont
    font.pixelSize: Theme.size
    font.bold: true
  }
  Text {
    id: mem
    text: "MEM --GB"
    color: Theme.palette.fg
    font.family: Theme.barFont
    font.pixelSize: Theme.size
    font.bold: true
  }
  Timer {
    running: true
    repeat: true
    interval: 2000
    onTriggered: statProc.running = true
  }
  Process {
    id: statProc
    command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d. -f1; free -g | awk '/Mem:/ {print $3}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        if (lines.length >= 2) {
          cpu.text = "CPU " + lines[0] + "%";
          mem.text = "MEM " + lines[1] + "GB";
        }
      }
    }
  }
}
