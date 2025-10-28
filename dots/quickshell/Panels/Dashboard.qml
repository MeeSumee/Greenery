import QtQuick
import QtQuick.Layouts
import qs.Widgets as Wid
import qs.Data as Dat
import Quickshell.Services.SystemTray

Rectangle {
  id: dashboard

  Layout.fillHeight: true
  Layout.fillWidth: true

  color: "transparent"

  GridLayout {
    id: dashgrid
    anchors.margins: 6        
    anchors.fill: parent
    flow: GridLayout.TopToBottom
    rows: 2
    columnSpacing: 5

    Rectangle {
      Layout.rowSpan: 2

      implicitHeight: 340
      implicitWidth: 270
      radius: 20
      color: "transparent"

      border {
        width: 1
        color: Dat.Colors.foreground
      }

      Wid.StatusTray {
        stackView: 0
      }
    }

    Rectangle {
      Layout.rowSpan: 2
      implicitHeight: 340
      implicitWidth: 300
      radius: 20
      color: "transparent"

      border {
        width: 1
        color: Dat.Colors.foreground
      }

      Wid.Calendar {
      }
    }

    Rectangle {
      Layout.rowSpan: 2
      implicitHeight: 340
      implicitWidth: 310
      radius: 20
      color: "transparent"

      border {
        width: 1
        color: Dat.Colors.foreground 
      }

      Wid.WeatherWidget {
      }
    }
  }
}
