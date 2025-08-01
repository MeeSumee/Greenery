import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Widgets as Wid
import qs.Data as Dat
import qs.Panels as Pan

Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    y: 27
    color: Dat.Colors.background
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
                radius: 30

                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                Layout.margins: 4

                height: parent.height / 7

                color: "red"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: content.currentIndex = 0
                }
            }

            Rectangle {
                id: button2
                radius: 30

                Layout.fillWidth: true
                Layout.margins: 4
                Layout.alignment: button1.Qt.AlignBottom

                height: parent.height / 7

                color: "orange"
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: content.currentIndex = 1
                }               
            }

            Rectangle {
                id: button3
                radius: 30

                Layout.fillWidth: true
                Layout.margins: 4
                Layout.alignment: button2.Qt.AlignBottom

                height: parent.height / 7

                color: "yellow"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: content.currentIndex = 2
                }
            }

            Rectangle {
                id: button4
                radius: 30

                Layout.fillWidth: true
                Layout.margins: 4
                Layout.alignment: button3.Qt.AlignBottom

                height: parent.height / 7

                color: "green"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: content.currentIndex = 3
                }
            }

            Rectangle {
                id: button5
                radius: 30

                Layout.fillWidth: true
                Layout.margins: 4
                Layout.alignment: button4.Qt.AlignBottom

                height: parent.height / 7

                color: "blue"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: content.currentIndex = 4
                }
            }

            Rectangle {
                id: button6
                radius: 30

                Layout.fillWidth: true
                Layout.margins: 5
                Layout.alignment: Qt.AlignBottom

                height: parent.height / 7

                color: "purple"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
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
        implicitHeight: parent.implicitHeight
        implicitWidth: 930.5

        StackLayout {
            id: content
            anchors.fill: parent

            Pan.Dashboard {
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Dat.MaterialEasing.standardAccelTime
                        easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    }
                }
            }

            Pan.Media {
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Dat.MaterialEasing.standardAccelTime
                        easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    }
                }
            }

            Pan.Notifications {
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Dat.MaterialEasing.standardAccelTime
                        easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    }
                }
            }

            Pan.System {
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Dat.MaterialEasing.standardAccelTime
                        easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    }
                }
            }

            Pan.Performance {
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Dat.MaterialEasing.standardAccelTime
                        easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    }
                }
            }

            Pan.Settings {
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Dat.MaterialEasing.standardAccelTime
                        easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    }
                }
            }
        }
    }
}
