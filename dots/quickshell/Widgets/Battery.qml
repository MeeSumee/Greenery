import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import "../Data" as Dat

Rectangle {
  id: root

  readonly property bool batCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
  readonly property string batIcon: {
    (batPercentage > 0.98) ? batIcons[0] : (batPercentage > 0.90) ? batIcons[1] : (batPercentage > 0.80) ? batIcons[2] : (batPercentage > 0.70) ? batIcons[3] : (batPercentage > 0.60) ? batIcons[4] : (batPercentage > 0.50) ? batIcons[5] : (batPercentage > 0.40) ? batIcons[6] : (batPercentage > 0.30) ? batIcons[7] : (batPercentage > 0.20) ? batIcons[8] : (batPercentage > 0.10) ? batIcons[9] : batIcons[10];
  }
  readonly property list<string> batIcons: ["󰁹", "󰂂", "󰂁", "󰂀", "󰁿", "󰁾", "󰁽", "󰁼", "󰁻", "󰁺", "󰂃"]
  readonly property real batPercentage: UPower.displayDevice.percentage
  readonly property string chargeIcon: batIcons[10 - chargeIconIndex]
  property int chargeIconIndex: 0
  property bool hasBattery: UPower.displayDevice.percentage > 0

  Layout.minimumWidth: contentRow.width ? contentRow.width : 1
  color: Dat.Colors.foreground

  Behavior on Layout.minimumWidth {
    NumberAnimation {
      duration: 150
      easing.type: Easing.Linear
    }
  }

  RowLayout {
    id: contentRow

    anchors.centerIn: parent
    height: parent.height
    spacing: 0

    Item {
      Layout.fillHeight: true
      implicitWidth: batText.contentWidth + 16
      visible: root.hasBattery

      Text {
        id: batText

        anchors.centerIn: parent
        color: Dat.Colors.foreground
        font.pointSize: 11
        text: Math.round(root.batPercentage * 100) + "%"
        visible: UPower.displayDevice.percentage > 0
      }
    }

    Rectangle {
      Layout.fillHeight: true
      color: Dat.Colors.foreground
      implicitWidth: this.height
      radius: this.height

      Text {
        anchors.centerIn: parent
        color: Dat.Colors.foreground
        font.pointSize: (!root.hasBattery) ? 9 : 11
        text: (!root.hasBattery) ? root.profileIcon : ((root.batCharging) ? root.chargeIcon : root.batIcon)
      }
    }
  }
}