import QtQuick
import Quickshell
import Quickshell.Wayland
import "components"
import QtQuick.Controls  // For Screen API

PanelWindow {
    id: panel
    anchors {
        top: true
        left: true
        right: true
    }

    color: "lime"
    implicitHeight: 30
    height: expanded ? Screen.height / 3 : 30

    property bool expanded: false

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: panel.expanded = !panel.expanded

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    Text {
        anchors.centerIn: parent
        anchors.top: parent
        text: expanded ? "" : "I AM SBEVE "
    }

    Rectangle {
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
            topMargin: 30
        }
        width: parent.width / 3
        color: "yellow"
    }

    Rectangle { // Right side box
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            topMargin: 30
        }
        width: parent.width / 8
        color: "red"
    }


    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }
}



