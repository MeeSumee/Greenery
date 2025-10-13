import QtQuick
import QtQuick.Layouts
import qs.Data as Dat

Rectangle {
  id: system

  Layout.fillHeight: true
  Layout.fillWidth: true

  color: "transparent"

  GridLayout {
    id: systemgrid
    anchors.margins: 6        
    anchors.fill: parent
    flow: GridLayout.TopToBottom
    rows: 2
    columnSpacing: 5

    Rectangle {
      Layout.rowSpan: 2

      implicitHeight: 330
      implicitWidth: 915
      color: "transparent"
      radius: 20

      border {
        width: 1
        color: Dat.Colors.foreground
      }

      Text {
        anchors.centerIn: parent
        text: "PERFORMANCE AND PARAMETERS"
        color: Dat.Colors.foreground
      }
    }
  }
}
