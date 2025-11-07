import QtQuick
import QtQuick.Layouts
import qs.Widgets as Wid
import qs.Data as Dat

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

      Rectangle {
        implicitWidth: parent.implicitWidth
        implicitHeight: parent.implicitHeight / 6
        topLeftRadius: parent.radius
        topRightRadius: parent.radius
        anchors.top: parent.top
        color: "transparent"

        border {
          width: 1
          color: Dat.Colors.foreground
        }

        Wid.SessionControl {
        }
      }


      Rectangle {
        implicitWidth: parent.implicitWidth
        implicitHeight: parent.implicitHeight / 6
        bottomLeftRadius: parent.radius
        bottomRightRadius: parent.radius
        anchors.bottom: parent.bottom
        color: "transparent"

        border {
          width: 1
          color: Dat.Colors.foreground
        }

        Wid.StatusTray {
        }
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
