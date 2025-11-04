import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Item {
  anchors.bottom: parent.bottom
  height: parent.height
  width: rowL.width + 20

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
