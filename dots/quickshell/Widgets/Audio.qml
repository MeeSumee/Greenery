pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.Data as Dat

Item {
  id: root

  property color bgColor: Dat.Colors.selection
  property color fgColor: node?.isStream ? Dat.Colors.purple : Dat.Colors.foreground
  required property PwNode node

  implicitHeight: 42

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true

      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        Text {
          color: root.node?.isStream ? Dat.Colors.purple : Dat.Colors.foreground
          font.pointSize: 10
          text: `${parseInt(root.node?.audio?.volume * 100)}%` ?? ""
          verticalAlignment: Text.AlignVCenter

          ClippingRectangle {
            anchors.left: parent.right
            anchors.leftMargin: 5
            implicitWidth: 240
            implicitHeight: 30
            color: "transparent"

            Text {
              id: audioname
              color: root.node?.isStream ? Dat.Colors.purple : Dat.Colors.foreground
              font.pointSize: 10
              text: (root.node?.isStream ? root.node?.name : (nameArea.containsMouse) ? root.node?.description : (root.node?.nickname) ? root.node?.nickname : root.node?.description) ?? "Unidentified"
              verticalAlignment: Text.AlignVCenter
              x: 0

              SequentialAnimation {
                running: {
                  if (audioname.contentWidth > 240) {
                    return true;
                  } else {
                    audioname.x = 0;
                  }
                }

                NumberAnimation {
                  target: audioname
                  property: "x"
                  from: 0
                  to: -audioname.contentWidth
                  duration: 5000
                }
              }

              MouseArea {
                id: nameArea

                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.top: parent.top
                hoverEnabled: true
                width: Math.min(parent.contentWidth, parent.width)
              }
            }
          }
        }
      }

      Rectangle {
        id: icon  
        required property bool active
        property color activeColor: Dat.Colors.foreground
        property color passiveColor: Dat.Colors.background

        Layout.fillHeight: true
        active: (root.node?.isSink) ? root.node == Pipewire.defaultAudioSink : root.node == Pipewire.defaultAudioSource
        implicitWidth: this.height
        radius: this.height
        color: active ? activeColor : passiveColor
        visible: !root.node?.isStream

        Dat.MaterialSymbols {
          anchors.centerIn: parent
          color: icon.active ? icon.passiveColor : icon.activeColor
          font.pointSize: 12
          icon: (!root.node?.isSink) ? (Pipewire.defaultAudioSource?.audio.muted ? "mic_off": "mic") : (Pipewire.defaultAudioSink?.audio.muted ? "volume_off" : "volume_up")
        }

        Behavior on color {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onClicked: {
            if (root.node?.isSink) {
              Pipewire.preferredDefaultAudioSink = root.node;
            } else {
              Pipewire.preferredDefaultAudioSource = root.node;
            }
          }
        }
      }
    }

    Item {
      Layout.fillWidth: true
      implicitHeight: 17

      Slider {
        id: slider

        anchors.fill: parent
        bottomInset: 0
        from: 0
        leftInset: 0
        padding: 0
        rightInset: 0
        snapMode: Slider.NoSnap
        to: 1
        topInset: 0
        value: root.node?.audio?.volume ?? 1

        background: ClippingRectangle {
          id: bgRect

          anchors.bottomMargin: 1
          anchors.fill: parent
          anchors.topMargin: 1
          antialiasing: true
          color: root.bgColor
          layer.smooth: true
          radius: 5

          Rectangle {
            id: progRect

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            antialiasing: true
            color: root.fgColor
            layer.smooth: true
            visible: true
            width: slider.visualPosition * parent.width
          }
        }
        handle: Rectangle {
          color: root.fgColor
          implicitHeight: 20
          implicitWidth: 10
          radius: 10
          x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width + 1)
          y: slider.topPadding + slider.availableHeight / 2 - height / 2
        }

        onMoved: {
          if (root.node) {
            root.node.audio.volume = slider.value;
          }
        }
      }
    }
  }
}
