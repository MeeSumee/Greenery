// Logo.qml
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Effects
import "../Data" as Dat

IconImage {
    id: root

    implicitHeight: 30
    implicitWidth: 30

    smooth: true
    asynchronous: true
    layer.enabled: true
    layer.effect: MultiEffect {
        colorization: 1
        colorizationColor: Dat.Colors.foreground
        brightness: 0.5
    }

    Process {
        running: true
        command: ["sh", "-c", ". /etc/os-release && echo $LOGO"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                root.source = Quickshell.iconPath(this.text.trim());
            }
        }
    }
}