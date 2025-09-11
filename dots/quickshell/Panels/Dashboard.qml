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

            Text {
                id: text1
                anchors.centerIn: parent
                text: "SYSTEM TRAY, SHUTDOWN,"
                color: Dat.Colors.foreground
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: text1.bottom
                text: "RESTART, LOCK, SLEEP, ETC"
                color: Dat.Colors.foreground
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
            Layout.rowSpan: 1
            implicitHeight: 225
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

        Rectangle {
          Layout.rowSpan: 1
          Layout.bottomMargin: 5
            implicitHeight: 100
            implicitWidth: 310
            radius: 20
            color: "transparent"

            border {
                width: 1
                color: Dat.Colors.foreground 
            }

            Wid.Event {

            }
        }
    }
}
