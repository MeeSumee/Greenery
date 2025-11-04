import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import qs.Widgets as Wid
import qs.Data as Dat

Rectangle {
  id: media

  Layout.fillHeight: true
  Layout.fillWidth: true

  color: "transparent"

  GridLayout {
    id: mediagrid
    anchors.margins: 6        
    anchors.fill: parent
    flow: GridLayout.TopToBottom
    rows: 2
    columnSpacing: 5

    Rectangle {
      Layout.rowSpan: 2

      implicitHeight: 340
      implicitWidth: 270
      color: "transparent"
      radius: 20

      border {
        width: 1
        color: Dat.Colors.foreground
      }

      Repeater {
        model: ScriptModel {
          values: [...Mpris.players.values]
        }

        Wid.Mpris {
          required property MprisPlayer modelData
          player: modelData
        }
      }
    }

    Rectangle {
      Layout.rowSpan: 2

      implicitHeight: 340
      implicitWidth: 310
      color: "transparent"
      radius: 20

      border {
        width: 1
        color: Dat.Colors.foreground
      }

      Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        clip: true
        color: "transparent"
        radius: parent.radius

        ListView {
          anchors.fill: parent
          anchors.margins: 10
          spacing: 12

          delegate: Wid.Audio {
            required property PwNode modelData

            implicitWidth: parent?.width ?? 0
            node: modelData
          }
          model: ScriptModel {
            id: sModel

            values: Pipewire.nodes.values.filter(node => node.audio).sort()
          }
        }

        PwObjectTracker {
          objects: sModel.values
        }
      }
    }

    Rectangle {
      Layout.rowSpan: 2

      implicitHeight: 340
      implicitWidth: 300
      color: "transparent"
      radius: 20

      border {
        width: 1
        color: Dat.Colors.foreground
      }      

      Repeater {
        model: ScriptModel {
          values: [...Mpris.players.values]
        }
        
        Wid.Nahida {
          required property MprisPlayer modelData
          player: modelData
        }
      }
    }
  }
}
