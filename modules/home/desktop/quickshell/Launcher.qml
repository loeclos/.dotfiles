// Launcher.qml — drun/run + keybinds + nixosrebuild + powermenu
// Replaces: rofi (700x343, ❯ prompt, fzf sort),
// rofi-keybinds, rofi-nixosrebuild, wlogout.
// (wifi/bluetooth live in BarPopups.qml as smooth bar dropdowns.)
// Toggle: `quickshell ipc call launcher toggle <mode>` where mode is
// apps|keybinds|rebuild|powermenu (empty = toggle current).
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
  id: root
  property bool open: false
  property string mode: "apps"
  property var items: []

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
    root.updateModel("");
  }

  function updateModel(filter: string): void {
    const f = filter.toLowerCase();
    if (root.mode === "apps") {
      const all = DesktopEntries.applications.values.slice();
      all.sort((a, b) => a.name.localeCompare(b.name));
      root.items = all.filter(e => e.name.toLowerCase().includes(f)).slice(0, 8).map(e => ({
        label: e.name,
        sub: e.comment ?? "",
        run: () => { e.execute(); root.open = false; }
      }));
    } else if (root.mode === "keybinds") {
      root.items = keybindItems.filter(e => e.label.toLowerCase().includes(f));
    } else if (root.mode === "rebuild") {
      root.items = rebuildItems.filter(e => e.label.toLowerCase().includes(f));
    } else if (root.mode === "powermenu") {
      root.items = powerItems.filter(e => e.label.toLowerCase().includes(f));
    }
  }

  // --- static models (keep in sync with hyprland/keybinds.nix) ---
  property var keybindItems: [
    { label: "SUPER + ENTER", sub: "Open Terminal", run: () => { Quickshell.execDetached(["ghostty"]); root.open = false; } },
    { label: "SUPER + B", sub: "Open Browser", run: () => { Quickshell.execDetached(["brave"]); root.open = false; } },
    { label: "SUPER + E", sub: "Open File Manager (Nautilus)", run: () => { Quickshell.execDetached(["nautilus"]); root.open = false; } },
    { label: "SUPER + I", sub: "WiFi bar menu", run: () => { Quickshell.execDetached(["quickshell", "ipc", "call", "popups", "toggle", "wifi"]); root.open = false; } },
    { label: "SUPER + SHIFT + B", sub: "Bluetooth bar menu", run: () => { Quickshell.execDetached(["quickshell", "ipc", "call", "popups", "toggle", "bluetooth"]); root.open = false; } },
    { label: "SUPER + N", sub: "Open Neovim", run: () => { Quickshell.execDetached(["ghostty", "--class=ghostty.nvim", "-e", "nvim"]); root.open = false; } },
    { label: "SUPER + Q", sub: "Close Window", run: () => { Quickshell.execDetached(["hyprctl", "dispatch", "killactive"]); root.open = false; } },
    { label: "SUPER + F", sub: "Toggle Fullscreen", run: () => { Quickshell.execDetached(["hyprctl", "dispatch", "fullscreen"]); root.open = false; } },
    { label: "SUPER + W", sub: "Toggle Float", run: () => { Quickshell.execDetached(["hyprctl", "dispatch", "togglefloating"]); root.open = false; } },
    { label: "F6 / F5", sub: "Brightness Up / Down", run: () => { root.open = false; } },
    { label: "F3 / F2", sub: "Volume Up / Down", run: () => { root.open = false; } },
    { label: "SUPER + SPACE", sub: "App Launcher", run: () => root.toggle("apps") },
    { label: "SUPER + ESC", sub: "Power Menu", run: () => root.toggle("powermenu") },
    { label: "SUPER + SHIFT + SPACE", sub: "Toggle Bar", run: () => { Quickshell.execDetached(["quickshell", "ipc", "call", "bar", "toggle"]); root.open = false; } },
    { label: "SUPER + SHIFT + W", sub: "Terminal (Walt)", run: () => { Quickshell.execDetached(["ghostty", "--class=ghostty.walt", "-e", "walt"]); root.open = false; } },
    { label: "SUPER + S", sub: "Toggle Screensaver", run: () => { Quickshell.execDetached(["sh", "-c", "pkill -x hyprsaver || hyprsaver"]); root.open = false; } },
    { label: "SUPER + CTRL + K", sub: "Keybinds Menu", run: () => root.toggle("keybinds") },
    { label: "SUPER + SHIFT + R", sub: "Rebuild Menu", run: () => root.toggle("rebuild") },
    { label: "SUPER + TAB", sub: "Toggle Layout", run: () => { root.open = false; } },
    { label: "SUPER + 1..9", sub: "Workspace 1..9", run: () => { root.open = false; } },
    { label: "SUPER + SHIFT + 1..9", sub: "Move to Workspace 1..9", run: () => { root.open = false; } }
  ]

  // --- nixos-rebuild matrix (keep hosts in sync with flake.nix nixosConfigurations) ---
  function rebuildCmd(host: string, action: string): string {
    const dir = "$HOME/.dotfiles";
    if (action === "switch") return "sudo nixos-rebuild switch --flake " + dir + "#" + host;
    if (action === "upgrade") return "sudo nixos-rebuild switch --flake " + dir + "#" + host + " --upgrade";
    if (action === "build") return "sudo nixos-rebuild build --flake " + dir + "#" + host;
    if (action === "boot") return "sudo nixos-rebuild boot --flake " + dir + "#" + host;
    return "sudo nixos-rebuild test --flake " + dir + "#" + host;
  }
  function runInTerminal(cmd: string): void {
    Quickshell.execDetached(["ghostty", "-e", "bash", "-c", cmd + "; echo; echo 'Done. Press Enter to close.'; read"]);
    root.open = false;
  }
  property var rebuildItems: {
    const hosts = ["desktop", "laptop"];
    const actions = [["switch", "Rebuild & switch"], ["upgrade", "Rebuild & switch (update inputs)"], ["build", "Build only, no switch"], ["boot", "Build & add to boot menu"], ["test", "Build & test (no boot entry)"]];
    let out = [];
    for (const h of hosts) {
      const cap = h.charAt(0).toUpperCase() + h.slice(1);
      for (const a of actions) {
        const cmd = root.rebuildCmd(h, a[0]);
        out.push({ label: cap + " (" + a[0] + ")", sub: a[1] + " to " + h + " flake", run: () => root.runInTerminal(cmd) });
      }
    }
    out.push({ label: "Current host (switch)", sub: "Rebuild current system via flake", run: () => root.runInTerminal("sudo nixos-rebuild switch --flake $HOME/.dotfiles") });
    out.push({ label: "Live ISO (build)", sub: "Build live installer ISO", run: () => root.runInTerminal("sudo nixos-rebuild build --flake $HOME/.dotfiles#live") });
    out.push({ label: "GC (cleanup)", sub: "Collect garbage & optimise", run: () => root.runInTerminal("sudo nix-collect-garbage -d && sudo nix-store --optimise") });
    return out;
  }

  property var powerItems: [
    { label: "Lock", sub: "Lock session (hyprlock)", run: () => { Quickshell.execDetached(["sh", "-c", "pidof hyprlock || hyprlock"]); root.open = false; } },
    { label: "Logout", sub: "Exit Hyprland", run: () => { Quickshell.execDetached(["hyprctl", "dispatch", "exit"]); root.open = false; } },
    { label: "Suspend", sub: "Suspend system", run: () => { Quickshell.execDetached(["systemctl", "suspend"]); root.open = false; } },
    { label: "Reboot", sub: "Reboot system", run: () => { Quickshell.execDetached(["systemctl", "reboot"]); root.open = false; } },
    { label: "Poweroff", sub: "Power off system", run: () => { Quickshell.execDetached(["systemctl", "poweroff"]); root.open = false; } }
  ]

  IpcHandler {
    target: "launcher"
    function toggle(mode: string): void { root.toggle(mode); }
  }

  Variants {
    model: Quickshell.screens
    PanelWindow {
      id: window
      required property var modelData
      screen: modelData
      // Stay visible through the fade-out so the close animates instead of popping.
      visible: root.open || panel.opacity > 0
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
      MouseArea {
        anchors.fill: parent
        onClicked: root.open = false
      }
      Rectangle {
        id: panel
        anchors.centerIn: parent
        implicitWidth: 700
        implicitHeight: 343
        radius: Theme.radius
        color: Theme.palette.bg0
        border.color: Theme.palette.surface
        border.width: 1
        opacity: root.open ? 1 : 0
        scale: root.open ? 1 : 0.97
        Behavior on opacity {
          NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
          NumberAnimation { duration: Theme.animMed; easing.type: Easing.OutCubic }
        }
        MouseArea {
          anchors.fill: parent
          onClicked: mouse => mouse.accepted = true
        }
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 2
          spacing: 2
          Rectangle {
            Layout.fillWidth: true
            implicitHeight: 36
            color: Theme.palette.bg
            RowLayout {
              anchors.fill: parent
              anchors.leftMargin: 10
              anchors.rightMargin: 10
              spacing: 6
              Text {
                text: "❯"
                color: Theme.palette.accent
                font.family: Theme.sans
                font.pixelSize: Theme.size
              }
              TextInput {
                id: filter
                Layout.fillWidth: true
                color: Theme.palette.fg
                font.family: Theme.sans
                font.pixelSize: Theme.size
                focus: root.open
                onTextChanged: {
                  if (root.mode === "apps" || root.mode === "keybinds" || root.mode === "rebuild" || root.mode === "powermenu") root.updateModel(text);
                }
                Keys.onPressed: e => {
                  if (e.key === Qt.Key_Escape) root.open = false;
                  else if (e.key === Qt.Key_Down) { list.currentIndex = Math.min(list.currentIndex + 1, list.count - 1); e.accepted = true; }
                  else if (e.key === Qt.Key_Up) { list.currentIndex = Math.max(list.currentIndex - 1, 0); e.accepted = true; }
                  else if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) { if (list.currentIndex >= 0 && list.currentIndex < root.items.length) root.items[list.currentIndex].run(); e.accepted = true; }
                }
              }
            }
          }
          ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.items
            highlight: Rectangle { color: Theme.palette.accent }
            highlightMoveDuration: Theme.animFast
            delegate: Rectangle {
              required property var modelData
              required property int index
              width: list.width
              implicitHeight: 32
              color: list.currentIndex === index ? Theme.palette.accent : "transparent"
              Behavior on color {
                ColorAnimation { duration: Theme.animFast }
              }
              Text {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                verticalAlignment: Text.AlignVCenter
                text: modelData.label + (modelData.sub !== "" ? "  ❯  " + modelData.sub : "")
                elide: Text.ElideRight
                color: list.currentIndex === index ? Theme.palette.bg0 : Theme.palette.fgAlt
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
