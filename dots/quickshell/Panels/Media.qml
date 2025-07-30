import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../Widgets" as Wid
import "../Data" as Dat
import "../Properties" as Prop

Rectangle {
    id: media

    anchors.fill: parent

    color: "#800000FF"

    GridLayout {
        id: mediagrid
        anchors.margins: 6        
        anchors.fill: parent
        flow: GridLayout.TopToBottom
        rows: 2
        columnSpacing: 5

        Rectangle {
            Layout.rowSpan: 1

            height: 160
            width: 600
            color: "magenta"
        }

        Rectangle {
            Layout.rowSpan: 1

            height: 160
            width: 600
            color: "gold"
        }

        Rectangle {
            Layout.rowSpan: 2

            height: 330
            width: 300
            color: "lime"
        }
    }
}