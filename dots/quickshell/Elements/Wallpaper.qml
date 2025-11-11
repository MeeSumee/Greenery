import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Data as Dat

Variants {
  model: Quickshell.screens

  WlrLayershell {
    id: layerRoot

    required property ShellScreen modelData

    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    anchors.top: true
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    implicitHeight: 28
    layer: WlrLayer.Bottom
    namespace: "wallpaper"
    screen: modelData
    surfaceFormat.opaque: false

    Dat.Background {
      id: wallpaper
      anchors.fill: parent
      source: ""

      Component.onCompleted: source = Dat.Config.wallSrc
    }

    Rectangle {
      anchors.right: parent.right
      clip: true
      color: "transparent"
      height: layerRoot.screen.height
      width: 0

      Dat.Background {
        anchors.right: parent.right
        height: layerRoot.height
        source: ""
        width: layerRoot.width
      }
    }
  }
}
