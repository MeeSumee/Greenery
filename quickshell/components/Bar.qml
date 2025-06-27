// Bar.qml
import Quickshell

Scope {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData
            color: 'transparent'
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            ClockWidget {
                anchors.centerIn: parent

                // no more time binding
            }
        }
    }
}
