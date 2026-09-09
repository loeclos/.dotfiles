// Battery.qml — UPower display device, warning/critical colors (cf. waybar battery states)
import QtQuick
import Quickshell.Services.UPower

Text {
  property var dev: UPower.displayDevice
  property int pct: Math.round((dev?.percentage ?? 0) * 100)
  property bool charging: (dev?.state ?? 0) === UPowerDeviceState.Charging
  property string icon: charging ? Theme.icons.charging : (pct >= 90 ? Theme.icons.batteryFull : (pct >= 60 ? Theme.icons.battery34 : (pct >= 40 ? Theme.icons.batteryHalf : (pct >= 15 ? Theme.icons.batteryQuarter : Theme.icons.batteryEmpty))))
  text: pct + "% " + icon
  color: charging ? Theme.palette.fg : (pct <= 15 ? Theme.palette.brightRed : (pct <= 30 ? Theme.palette.orange : Theme.palette.fg))
  font.family: Theme.barFont
  font.pixelSize: Theme.size
  font.bold: true
}
