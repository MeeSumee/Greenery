import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Rectangle {
  id: root

  readonly property real batPercentage: UPower.displayDevice.percentage
  property bool hasBattery: UPower.displayDevice.percentage > 0

  Layout.minimumWidth: contentRow.width ? contentRow.width : 1

  Behavior on Layout.minimumWidth {
    NumberAnimation {
      duration: 150
      easing.type: Easing.Linear
    }
  }

  RowLayout {
    id: contentRow

    anchors.centerIn: parent
    spacing: 0

    Item {
      implicitWidth: batText.contentWidth + 16
      visible: root.hasBattery

      Text {
        id: batText

        anchors.centerIn: parent
        font.pointSize: 11
        text: Math.round(root.batPercentage * 100) + "%"
        visible: UPower.displayDevice.percentage > 0
      }
    }
  }
}
