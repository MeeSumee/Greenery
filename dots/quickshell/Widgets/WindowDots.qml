pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Niri
import qs.Data as Dat

Rectangle {
  id: root

  implicitWidth: parent.implicitWidth / 2
  implicitHeight: 30
  color: "transparent"

  RowLayout {
    anchors.fill: parent

    Repeater {
      model: Niri.workspaces.length
      WorkspaceItem {
        Layout.alignment: Qt.AlignCenter
      }
    }

    component WorkspaceItem: Rectangle {
      id: workspaceItem
      required property int index
      readonly property Workspace workspace: Niri.workspaces[index]
      readonly property bool active: workspace.isFocused

      radius: 20
      implicitWidth: active ? 40 : 20
      implicitHeight: 20

      color: active ? Dat.Colors.foreground : Dat.Colors.blue

      Behavior on implicitWidth {
        NumberAnimation {
          duration: Dat.MaterialEasing.standardAccelTime
          easing.bezierCurve: Dat.MaterialEasing.standardAccel
        }
      }

      Behavior on color {
        ColorAnimation {
          duration: Dat.MaterialEasing.standardAccelTime
          easing.bezierCurve: Dat.MaterialEasing.standardAccel
        }
      }
    }
  }
}
