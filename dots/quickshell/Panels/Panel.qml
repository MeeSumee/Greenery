import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../Widgets" as Wid
import "../Data" as Dat
import "../Properties" as Prop

Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    y: 26
    color: Dat.Colors.foreground
    radius: 25
    id: barpanel
    implicitHeight: 369 // Ensure overlap (shitty solution)
    implicitWidth: 1002 // Ensure overlap (shitty solution)

    Item {
        anchors.left: parent.left
        implicitHeight: parent.implicitHeight
        implicitWidth: 75

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "white"
                bottomLeftRadius: 25; topLeftRadius: 25
                
                StackLayout {
                    id: menulist

                    anchors.fill: parent

                // HOW DO I MAKE A FUCKING BUTTON
                }
            }
        }
    }
}
