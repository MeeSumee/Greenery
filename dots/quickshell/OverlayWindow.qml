// OverlayWindow.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: panel
    layer: WlrLayerShell.LayerTop  // Top layer for the panel
    width: Screen.width
    height: panelHeight
    color: "lime"

    property bool expanded: false
    property real panelHeight: expanded ? Screen.height / 3 + 30 : 30  // Adjust height when expanded

    // Main panel content
    MouseArea {
        anchors.fill: parent
        onClicked: panel.expanded = !panel.expanded
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    Text {
        anchors.centerIn: parent
        text: expanded ? "" : "I AM SBEVE"
    }

    // Expanded content - this is the section that grows/shrinks
    Rectangle {
        id: expandedContent
        width: parent.width
        height: expanded ? Screen.height / 3 : 0  // Only expand when 'expanded' is true
        color: "#ffffffcc"
        anchors.top: parent.bottom

        // Content inside the expanded section
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

        // Animate expansion and contraction
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    // MouseArea for closing (clicking outside the expanded area)
    MouseArea {
        id: outsideClickArea
        anchors.fill: parent
        onClicked: {
            if (panel.expanded) {
                panel.expanded = false  // Collapse if clicked outside
            }
        }
        opacity: panel.expanded ? 0.2 : 0  // Only show the area when expanded
    }
}
