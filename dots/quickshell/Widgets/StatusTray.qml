import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Rectangle {
  anchors.bottom: parent.bottom
  height: parent.height / 5
  width: rowL.width + 20
  color: "transparent"

  RowLayout {
    spacing: 10
    id: rowL
    anchors.centerIn: parent

    Repeater {
      model: SystemTray.items
      StatusTrayMenu {
        required property SystemTrayItem modelData
        item: modelData
      }
    }
  }
}
