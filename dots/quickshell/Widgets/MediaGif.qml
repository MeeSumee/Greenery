import QtQuick
import qs.Data as Dat

AnimatedImage {
  anchors.fill: parent
  anchors.centerIn: parent
  fillMode: Image.PreserveAspectFit
  playing: true
  source: "../Assets/camellya.gif"
  speed: 1
}

