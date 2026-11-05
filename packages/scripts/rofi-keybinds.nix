{ pkgs, apps }:
# Generated from modules/home/desktop/hyprland/keybinds.nix + lib/apps.nix —
# keep in sync if you change binds or the selected apps
pkgs.writeShellScriptBin "rofi-keybinds" ''
  #!/usr/bin/env bash
  binds="Print                         ❯  Screenshot (select region, file+clipboard to ~/Pictures/Screenshots)
  SUPER + ENTER                 ❯  Open Terminal (${apps.terminal.label})
  SUPER + A                     ❯  Open Agent (${apps.agent.label})
  SUPER + B                     ❯  Open Browser (${apps.browser.label})
  SUPER + E                     ❯  Open File Manager (${apps.fileManager.label})
  SUPER + I                     ❯  WiFi Menu
  SUPER + SHIFT + B             ❯  Bluetooth Menu
  SUPER + N                     ❯  Open Editor (${apps.editor.label})
  SUPER + S                     ❯  Open Spotify
  SUPER + CTRL + S              ❯  Toggle Screensaver
  SUPER + CTRL + B              ❯  System Monitor (btop)
  SUPER + Q                     ❯  Close Window
  SUPER + F                     ❯  Toggle Fullscreen
  SUPER + W                     ❯  Toggle Float
  F6                            ❯  Brightness Up
  F5                            ❯  Brightness Down
  F3                            ❯  Volume Up
  F2                            ❯  Volume Down
  SUPER + SPACE                 ❯  App Launcher
  SUPER + ESC                   ❯  Logout Menu
  SUPER + SHIFT + SPACE         ❯  Toggle Waybar
  SUPER + SHIFT + W             ❯  Terminal (Walt)
  SUPER + H                     ❯  Focus Left
  SUPER + L                     ❯  Focus Right
  SUPER + K                     ❯  Focus Up
  SUPER + J                     ❯  Focus Down
  SUPER + SHIFT + H             ❯  Swap Left
  SUPER + SHIFT + L             ❯  Swap Right
  SUPER + SHIFT + K             ❯  Swap Up
  SUPER + SHIFT + J             ❯  Swap Down
  SUPER + /                     ❯  Keybinds Menu
  SUPER + CTRL + H              ❯  Resize Left
  SUPER + CTRL + L              ❯  Resize Right
  SUPER + CTRL + K              ❯  Resize Up
  SUPER + CTRL + J              ❯  Resize Down
  SUPER + TAB                   ❯  Toggle Layout
  SUPER + 1                     ❯  Workspace 1
  SUPER + 2                     ❯  Workspace 2
  SUPER + 3                     ❯  Workspace 3
  SUPER + 4                     ❯  Workspace 4
  SUPER + 5                     ❯  Workspace 5
  SUPER + 6                     ❯  Workspace 6
  SUPER + 7                     ❯  Workspace 7
  SUPER + 8                     ❯  Workspace 8
  SUPER + 9                     ❯  Workspace 9
  SUPER + SHIFT + 1             ❯  Move to Workspace 1
  SUPER + SHIFT + 2             ❯  Move to Workspace 2
  SUPER + SHIFT + 3             ❯  Move to Workspace 3
  SUPER + SHIFT + 4             ❯  Move to Workspace 4
  SUPER + SHIFT + 5             ❯  Move to Workspace 5
  SUPER + SHIFT + 6             ❯  Move to Workspace 6
  SUPER + SHIFT + 7             ❯  Move to Workspace 7
  SUPER + SHIFT + 8             ❯  Move to Workspace 8
  SUPER + SHIFT + 9             ❯  Move to Workspace 9"

  echo "$binds" | rofi -dmenu -i -p "Binds"
''
