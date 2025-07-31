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

    color: "#64535a10"

    GridLayout {
        id: systemgrid
        anchors.margins: 6        
        anchors.fill: parent
        flow: GridLayout.TopToBottom
        rows: 2
        columnSpacing: 5

        Rectangle {
            Layout.rowSpan: 2

            height: 330
            width: 600
            color: "firebrick"
        }

        Rectangle {
            Layout.rowSpan: 2

            height: 330
            width: 300
            color: "ivory"
        }
    }
}