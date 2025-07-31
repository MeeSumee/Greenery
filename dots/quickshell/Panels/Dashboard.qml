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
            Layout.rowSpan: 1

            height: 160
            width: 250
            color: "magenta"
        }

        Rectangle {
            Layout.rowSpan: 1

            height: 160
            width: 250
            color: "gold"
        }

        Rectangle {
            Layout.rowSpan: 2

            height: 340
            width: 350
        }

        Rectangle {
            Layout.rowSpan: 2
            height: 340
            width: 300
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
    }
}