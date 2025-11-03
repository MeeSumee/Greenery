// Mostly yoinked from RexCrazy804
import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.Data as Dat

Item {
  anchors.horizontalCenter: parent.horizontalCenter
  height: parent.height
  width: parent.width

  RowLayout {
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width

    Repeater {

      function poweroff() {
        Quickshell.execDetached(["poweroff"]);
      }

      function reboot() {
        Quickshell.execDetached(["reboot"]);
      }

      function suspend() {
        Quickshell.execDetached(["loginctl", "lock-session"]);
        Quickshell.execDetached(["systemctl", "suspend"]);
      }

      function lock() {
        Quickshell.execDetached(["loginctl", "lock-session"]);
      }

      model: [
        {
          text: "󰐥",
          action: event => poweroff()
        },
        {
          text: "󰜉",
          action: event => reboot()
        },
        {
          text: "󰤄",
          action: event => suspend()
        },
        {
          text: "⚷",
          action: event => lock()
        },
      ]

      delegate: Rectangle {
        id: dot

        required property var modelData

        Layout.alignment: Qt.AlignCenter
        clip: true
        color: Dat.Colors.foreground
        opacity: 1
        implicitHeight: this.implicitWidth
        implicitWidth: 36
        radius: this.implicitWidth

        MouseArea {
          id: marea
          anchors.fill: parent
          hoverEnabled: true
          onExited: dot.opacity = 1
          onEntered: dot.opacity = 0.6
          onClicked: mevent => dot.modelData.action(mevent)
        }

        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.background
          font.bold: true
          font.pointSize: 20
          text: dot.modelData.text
        }
      }
    }
  }
}
