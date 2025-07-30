import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../Widgets" as Wid
import "../Data" as Dat
import "../Properties" as Prop

Rectangle {
    id: notifications

    anchors.fill: parent

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