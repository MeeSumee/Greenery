import Quickshell
import QtQuick.Layouts
import QtQuick
import qs.Data as Dat

RowLayout {
    anchors.top: parent.top
    spacing: 5

    Dat.MaterialSymbols {
        id: icon
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop

        text: Dat.Weather.icon || "cloud_alert"
        color: Dat.Colors.foreground
        font.pointSize: 24
    }

    Text {
        Layout.alignment: Qt.AlignLeft
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF : Dat.Weather.tempC
        color: Dat.Colors.foreground
        font.pointSize: 24
        font.weight: 500
    }
}
