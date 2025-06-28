import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        Rectangle {
            id: topBar
            width: parent.width
            height: hovered ? 200 : 40  // expands on hover
            color: "#222"
            anchors.top: parent.top

            property bool hovered: false

            Behavior on height {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            Bar {
                anchors.left: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: topBar.hovered = true
                onExited: topBar.hovered = false
            }

            Column {
                anchors.fill: parent
                spacing: 10
                padding: 10

                Text { text: "Status Bar" }
                Row {
                    visible: topBar.hovered
                    spacing: 8
                    Text { text: "WiFi" }
                    Text { text: "Bluetooth" }
                    Text { text: "Battery" }
                }
            }
        }
    }
}
