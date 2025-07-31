import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Widgets as Wid
import qs.Data as Dat

Rectangle {
    id: notifications

    Layout.fillHeight: true
    Layout.fillWidth: true

    color: "#8000fffb"

    GridLayout {
        id: notifgrid
        anchors.margins: 6        
        anchors.fill: parent
        flow: GridLayout.TopToBottom
        rows: 2
        columnSpacing: 5

        Rectangle {
            Layout.rowSpan: 2

            height: 330
            width: 600
            color: "coral"
        }

        Rectangle {
            Layout.rowSpan: 2

            height: 330
            width: 300
            color: "bisque"
        }
    }
}