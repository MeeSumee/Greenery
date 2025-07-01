import QtQuick
import Quickshell
import Quickshell.Wayland
import "components"
import QtQuick.Controls

PanelWindow {
    id: panel
    WlrLayershell.layer: WlrLayer.Top  // Top layer so it floats above other windows
    implicitWidth: Screen.implicitWidth
    implicitHeight: expanded ? Screen.implicitHeight / 3 + 30 : 30  // Adjust the height based on expansion
    anchors {
        top: true
        left: true
        right: true
    }
    color: "lime"

    property bool expanded: false

    // The main bar content (top part of the bar)
    MouseArea {
        anchors.fill: parent
        onClicked: panel.expanded = !panel.expanded  // Toggle expansion
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    Text {
        anchors.centerIn: parent
        text: expanded ? "" : "I AM SBEVE"
    }

    // Expanded content (inside the same panel)
    Rectangle {
        id: expandedContent
        width: parent.width
        height: expanded ? Screen.height / 3 : 0
        color: "#ffffffcc"
        anchors.top: parent.bottom

        // Add some internal content
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

        Rectangle {
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
                topMargin: 30
            }
            width: parent.width / 3
            color: "red"
        }

        // Animate expansion
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    // Close behavior: If clicking outside, we collapse the panel
    MouseArea {
        id: outsideClickArea
        anchors.fill: parent
        onClicked: {
            if (panel.expanded) {
                panel.expanded = false
            }
        }
        opacity: panel.expanded ? 0.2 : 0  // Show it when expanded
    }
}
