import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Widgets as Wid
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
            implicitWidth: 600
            color: "transparent"
            radius: 20

            border {
              width: 1
              color: Dat.Colors.foreground
            }

            Text {
                anchors.centerIn: parent
                text: "WORKSPACES AND APP SWITCHER"
                color: Dat.Colors.foreground
            }
        }

        Rectangle {
            Layout.rowSpan: 2

            implicitHeight: 330
            implicitWidth: 300
            color: "transparent"
            radius: 20

            border {
              width: 1
              color: Dat.Colors.foreground
            }

            Text {
                anchors.centerIn: parent
                text: "SYSTEM PROFILE"
                color: Dat.Colors.foreground
            }
        }
    }
}
