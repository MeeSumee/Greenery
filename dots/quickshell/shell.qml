import QtQuick
import Quickshell
import Quickshell.Wayland
import "components"
import QtQuick.Controls  // For Screen API
import QtQuick.Layouts


PanelWindow {
    id: panel
    anchors {
        top: true
    }

    width: Screen.width / 2
    color: "lavender"
    height: expanded ? Screen.height / 3 : Screen.height / 35

    // Item Row in TopBar=============================================
    RowLayout {
        id: topRow
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        // anchors.margins: 8
        // spacing: 20

        // Left Icons/Items
        Item {
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                //spacing: 10

                Image {
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                    Layout.preferredWidth: Screen.height / 35
                    Layout.preferredHeight: Screen.height / 35
                    source: "icons/NixOS.png"


                }
            }
        }

        Item { // Spacer
            Layout.fillWidth: true
        }

        ClockWidget {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        // Spacer to push right side to the right
        Item {
            Layout.fillWidth: true
        }

        // Right side icons
        Item {
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                spacing: 10


            }
        }
    }


    // Dropdown Expansion of TopBar ======================
    property bool expanded: false

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: panel.expanded = !panel.expanded
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
    Behavior on height {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }
}








