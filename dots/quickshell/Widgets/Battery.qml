import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.Data as Dat

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
  property string profileIcon: switch (PowerProfiles.profile) {
  case 0:
    "";
    break;
  case 1:
    "";
    break;
  case 2:
    "";
    break;
  }

  Layout.minimumWidth: contentRow.width ? contentRow.width : 1
  color: Dat.Colors.background

  Behavior on Layout.minimumWidth {
    NumberAnimation {
      duration: 150
      easing.type: Easing.Linear
    }
  }

  RowLayout {
    id: contentRow

    anchors.left: parent.left
    height: parent.height
    spacing: 0

    Item {
      Layout.fillHeight: true
      implicitWidth: batText.contentWidth
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
      color: Dat.Colors.background
      implicitWidth: this.height
      radius: this.height

      Text {
        anchors.centerIn: parent
        color: Dat.Colors.foreground
        font.pointSize: 11
        text: (!root.hasBattery) ? root.profileIcon : ((root.batCharging) ? root.chargeIcon : root.batIcon)
      }
    }
  }

  Timer {
    interval: 600
    repeat: true
    running: root.batCharging

    onTriggered: () => {
      root.chargeIconIndex = root.chargeIconIndex % 10;
      root.chargeIconIndex += 1;
    }
  }
}
