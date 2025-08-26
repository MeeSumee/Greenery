import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Widgets as Wid
import qs.Data as Dat

Rectangle {
    id: media

    Layout.fillHeight: true
    Layout.fillWidth: true

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

            Text {
                anchors.centerIn: parent
                text: "MUSIC PLAYBACK"
            }
        }

        Rectangle {
            Layout.rowSpan: 1

            height: 160
            width: 600
            color: "gold"

            Text {
                anchors.centerIn: parent
                text: "AUDIO MIXER"
            }
        }

        Rectangle {
            Layout.rowSpan: 2

            height: 330
            width: 300
            color: "lime"

            Text {
                anchors.centerIn: parent
                text: "DANCING NAHIDA"
            }
        }
    }
}