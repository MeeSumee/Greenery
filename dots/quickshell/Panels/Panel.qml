import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../Widgets" as Wid
import "../Data" as Dat
import "../Panels" as Pan

Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    y: 26
    color: Dat.Colors.foreground
    radius: 25
    id: barpanel
    implicitHeight: 369 // Ensure overlap (shitty solution)
    implicitWidth: 1002 // Ensure overlap (shitty solution)

    // Buttons
    Item {
        anchors.left: parent.left
        implicitHeight: parent.implicitHeight
        implicitWidth: 61.5

        ColumnLayout {
            id: menulist

            anchors.fill: parent
            spacing: 0
            

            Rectangle {
                id: button1
                topLeftRadius: 25

                anchors.top: parent.top
                height: parent.height / 6
                width: parent.width

                color: "red"

                MouseArea {
                    anchors.fill: parent

                    onClicked: content.currentIndex = 0
                }
            }

            Rectangle {
                id: button2

                anchors.top: button1.bottom
                height: parent.height / 6
                width: parent.width

                color: "orange"
                
                MouseArea {
                    anchors.fill: parent

                    onClicked: content.currentIndex = 1
                }
            }

            Rectangle {
                id: button3

                anchors.top: button2.bottom
                height: parent.height / 6
                width: parent.width

                color: "yellow"

                MouseArea {
                    anchors.fill: parent

                    onClicked: content.currentIndex = 2
                }
            }

            Rectangle {
                id: button4

                anchors.top: button3.bottom
                height: parent.height / 6
                width: parent.width

                color: "green"

                MouseArea {
                    anchors.fill: parent

                    onClicked: content.currentIndex = 3
                }
            }

            Rectangle {
                id: button5

                anchors.top: button4.bottom
                height: parent.height / 6
                width: parent.width

                color: "blue"

                MouseArea {
                    anchors.fill: parent

                    onClicked: content.currentIndex = 4
                }
            }

            Rectangle {
                id: button6
                bottomLeftRadius: 25

                anchors.bottom: parent.bottom
                height: parent.height / 6
                width: parent.width

                color: "purple"

                MouseArea {
                    anchors.fill: parent

                    onClicked: content.currentIndex = 5
                }
            }
        }
    }

    // Content
    Item {
        anchors.margins: 10        
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: parent.implicitHeight - 20
        implicitWidth: 920.5

        StackLayout {
            id: content
            anchors.fill: parent

            Pan.Dashboard {}

            Pan.Media {}

            Pan.Notifications {}

            Pan.System {}

            Pan.Performance {}

            Pan.Settings {}
        }
    }
}
