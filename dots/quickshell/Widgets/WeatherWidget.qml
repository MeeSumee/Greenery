import Quickshell
import QtQuick
import qs.Data as Dat

Item {
    Dat.MaterialSymbols {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        text: Weather.icon || "cloud_alert"
        color: Dat.Colors.foreground
        font.pointSize: 24
    }

    Text {
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF : Dat.Weather.tempC
        color: Dat.Colors.foreground
        font.pointSize: 24
        font.weight: 500
    }
}