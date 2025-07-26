import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import "../Data" as Dat

Item {
    id: batteryWidget
    
    property var battery: UPower.displayDevice
    property bool isReady: battery && battery.ready && battery.isLaptopBattery && battery.isPresent
    property real percent: isReady ? (battery.percentage * 100) : 0
    property bool charging: isReady ? battery.state === UPowerDeviceState.Charging : false
    property bool show: isReady && percent > 0

    // Choose icon based on charge and charging state
    function batteryIcon() {
        if (!show) return "";
        if (percent >= 95) return "battery_full";
        if (percent >= 80) return "battery_80";
        if (percent >= 60) return "battery_60";
        if (percent >= 50) return "battery_50";
        if (percent >= 30) return "battery_30";
        if (percent >= 20) return "battery_20";
        return "battery_alert";
    }

    visible: isReady && battery.isLaptopBattery
    width: 22
    height: 36

    RowLayout {
        anchors.fill: parent
        spacing: 4
        visible: show
        Item {
            height: 22
            width: 22
            Text {
                text: batteryIcon()
                font.family: "Material Symbols Outlined"
                font.pixelSize: 14
                color: Dat.Colors.foreground
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent
            }
        }
    }
}