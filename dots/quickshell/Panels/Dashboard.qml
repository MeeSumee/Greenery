import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
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
            color: "gold"

            Text {
                id: text1
                anchors.centerIn: parent
                text: "SYSTEM TRAY, SHUTDOWN,"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: text1.bottom
                text: "RESTART, LOCK, SLEEP, ETC"
            }
        }

        Rectangle {
            Layout.rowSpan: 2
            implicitHeight: 340
            implicitWidth: 300
            radius: 20
            color: Dat.Colors.background
            opacity: 0.9

            border {
                width: 1
                color: Dat.Colors.foreground
            }

            Wid.Calendar {
                height: parent.height
                width: parent.width
            }
        }

        Rectangle {
            Layout.rowSpan: 2
            implicitHeight: 340
            implicitWidth: 310
            radius: 20
            color: Dat.Colors.background

            border {
                width: 1
                color: Dat.Colors.foreground 
            }

            Wid.WeatherWidget {
                height: parent.height
                width: parent.width
            }
        }
    }
}
