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
  property color fgColor: Dat.Colors.foreground
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
          color: Dat.Colors.foreground
          font.pointSize: 10
          text: (root.node?.isStream ? root.node?.name : (nameArea.containsMouse) ? root.node?.description : (root.node?.nickname) ? root.node?.nickname : root.node?.description) ?? "Unidentified"
          verticalAlignment: Text.AlignVCenter

          Text {
            anchors.left: parent.right
            anchors.leftMargin: 10
            color: Dat.Colors.foreground
            font.pointSize: 10
            text: `${parseInt(root.node?.audio?.volume * 100)}%` ?? ""
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

      Rectangle {
        id: icon  
        required property bool active
        property color activeColor: Dat.Colors.foreground
        property color passiveColor: Dat.Colors.pink

        color: Dat.Colors.selection

        Layout.fillHeight: true
        active: (root.node?.isSink) ? root.node == Pipewire.defaultAudioSink : root.node == Pipewire.defaultAudioSource
        implicitWidth: this.height
        radius: this.height
        visible: !root.node?.isStream

        Dat.MaterialSymbols {
          anchors.centerIn: parent
          color: Dat.Colors.foreground
          font.pointSize: 12
          icon: (!root.node?.isSink) ? "mic" : "volume_up"
        }

        MouseArea {
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
          color: Dat.Colors.foreground
          implicitHeight: 20
          implicitWidth: 10
          radius: 5
          x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width + 1)
          y: slider.topPadding + slider.availableHeight / 2 - height / 2

          Rectangle {
            anchors.centerIn: parent
            color: root.fgColor
            height: parent.height
            radius: 10
            width: 5
          }
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
