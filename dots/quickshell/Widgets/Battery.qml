import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import "../Data" as Dat

Rectangle {
  id: root

  readonly property bool batCharging: UPower.displayDevice.state == UPowerDeviceState.Charging

  property bool hasBattery: UPower.displayDevice.percentage > 0

  color: Dat.Colors.foreground

  Behavior on Layout.minimumWidth {
    NumberAnimation {
      duration: 150
      easing.type: Easing.Linear
    }
  }

  Text {
    id: batText

    anchors.centerIn: parent
    color: Dat.Colors.foreground
    font.pointSize: 11
    text: Math.round(root.batPercentage * 100) + "%"
    visible: UPower.displayDevice.percentage > 0
  }
}