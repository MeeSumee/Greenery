pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell.Services.Mpris

import qs.Data as Dat

Rectangle {
  id: rect
  required property MprisPlayer player
  anchors.fill: parent
  anchors.margins: 1
  clip: true
  color: "transparent"
  radius: 20

  Image {
    id: sourceItem
    source: rect.player.trackArtUrl
    anchors.centerIn: parent
    anchors.fill: parent
    visible: false
  }

  MultiEffect {
    source: sourceItem
    anchors.fill: sourceItem
    maskEnabled: true
    maskSource: mask
    opacity: 0.3
  }

  Item {
    id: mask
    width: sourceItem.width
    height: sourceItem.height
    layer.enabled: true
    visible: false

    Rectangle {
      width: sourceItem.width
      height: sourceItem.height
      radius: 20
      color: Dat.Colors.black
    }
  }
}

