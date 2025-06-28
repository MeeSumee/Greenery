// Bar.qml
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens

        delegate: WlrLayershell {
            id: bar

            required property ShellScreen modelData

            anchors.left: true
            anchors.right: true
            anchors.top: true
            color: "transparent"
            exclusionMode: ExclusionMode.Auto
            focusable: false
            implicitHeight: 20
            layer: WlrLayer.Top
            screen: modelData
            surfaceFormat.opaque: false

            Rectangle {
                anchors.fill: parent
            }
        }
    }
}
