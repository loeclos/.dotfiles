# modules/home/desktop/quickshell/default.nix — Quickshell shell (bar, notifications, launcher, bar popups)
# Replaces waybar + dunst + rofi + wifi/bluetooth-menu + rofi-keybinds + rofi-nixosrebuild + wlogout.
# Runtime (pkgs.quickshell) comes from modules/nixos/apps/system.nix; this module only ships config.
# Theme.qml + qmldir are generated from lib/theme.nix (single source of truth, no hardcoded hex).
{ theme, ... }:
{
  xdg.configFile = {
    "quickshell/shell.qml".source = ./shell.qml;
    "quickshell/Bar.qml".source = ./Bar.qml;
    "quickshell/BarPopups.qml".source = ./BarPopups.qml;
    "quickshell/Notifications.qml".source = ./Notifications.qml;
    "quickshell/Launcher.qml".source = ./Launcher.qml;
    "quickshell/Workspaces.qml".source = ./Workspaces.qml;
    "quickshell/Separator.qml".source = ./Separator.qml;
    "quickshell/Mpris.qml".source = ./Mpris.qml;
    "quickshell/Tray.qml".source = ./Tray.qml;
    "quickshell/NetBt.qml".source = ./NetBt.qml;
    "quickshell/Audio.qml".source = ./Audio.qml;
    "quickshell/SysStats.qml".source = ./SysStats.qml;
    "quickshell/Battery.qml".source = ./Battery.qml;
    "quickshell/Clock.qml".source = ./Clock.qml;

    # A qmldir disables quickshell's automatic component synthesis, so every
    # same-dir component must be declared here (singleton Theme + all views).
    "quickshell/qmldir".text = ''
      singleton Theme 1.0 Theme.qml
      Audio 1.0 Audio.qml
      Bar 1.0 Bar.qml
      BarPopups 1.0 BarPopups.qml
      Battery 1.0 Battery.qml
      Clock 1.0 Clock.qml
      Launcher 1.0 Launcher.qml
      Mpris 1.0 Mpris.qml
      NetBt 1.0 NetBt.qml
      Notifications 1.0 Notifications.qml
      Separator 1.0 Separator.qml
      SysStats 1.0 SysStats.qml
      Tray 1.0 Tray.qml
      Workspaces 1.0 Workspaces.qml
    '';

    # Generated from lib/theme.nix — mirrors waybar style.css + dunst.nix + rofi.nix values.
    "quickshell/Theme.qml".text = ''
      pragma Singleton
      import QtQuick
      import Quickshell

      Singleton {
        property var palette: ({
          bg0: "${theme.palette.bg0}",
          bg: "${theme.palette.bg}",
          bgAlt: "${theme.palette.bgAlt}",
          surface: "${theme.palette.surface}",
          fg: "${theme.palette.fg}",
          fgAlt: "${theme.palette.fgAlt}",
          muted: "${theme.palette.muted}",
          gray: "${theme.palette.gray}",
          border: "${theme.palette.border}",
          red: "${theme.palette.red}",
          brightRed: "${theme.palette.brightRed}",
          brightGreen: "${theme.palette.brightGreen}",
          brightYellow: "${theme.palette.brightYellow}",
          brightBlue: "${theme.palette.brightBlue}",
          brightAqua: "${theme.palette.brightAqua}",
          orange: "${theme.palette.orange}",
          accent: "${theme.palette.accent}"
        })
        property string sans: "${theme.fonts.sans}"
        property string barFont: "${theme.fonts.bar}"
        property int size: ${toString theme.fonts.size}
        property int sizeSmall: ${toString theme.fonts.sizeSmall}
        property int sizeLarge: ${toString theme.fonts.sizeLarge}
        // Motion + shape tokens: OutCubic slide/fade durations mirror the
        // Hyprland `smooth` bezier (cf. hyprland/settings.nix curve).
        property int animFast: 150
        property int animMed: 200
        property int radius: 10
        property int radiusSmall: 6
        property int popupWidth: 340
        // Nerd Font icons as codepoints (literal PUA glyphs get mangled by
        // tooling, so fromCodePoint keeps this file pure ASCII). Every value
        // below was verified present in DepartureMonoNerdFont-Regular.otf.
        property var icons: ({
          wifi: String.fromCodePoint(0xF1EB),
          ethernet: String.fromCodePoint(0xF0200),
          bluetoothOn: String.fromCodePoint(0xF293),
          bluetoothOff: String.fromCodePoint(0xF294),
          volume: String.fromCodePoint(0xF028),
          muted: String.fromCodePoint(0xF026),
          batteryFull: String.fromCodePoint(0xF240),
          battery34: String.fromCodePoint(0xF241),
          batteryHalf: String.fromCodePoint(0xF242),
          batteryQuarter: String.fromCodePoint(0xF243),
          batteryEmpty: String.fromCodePoint(0xF244),
          charging: String.fromCodePoint(0xF0E7),
          music: String.fromCodePoint(0xF001),
          expanded: String.fromCodePoint(0x25BC),
          collapsed: String.fromCodePoint(0x25BA)
        })
      }
    '';
  };
}
