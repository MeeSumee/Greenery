import QtQuick
import qs.Data as Dat
import Quickshell.Services.Mpris

Rectangle {
  id: root
  anchors.bottom: parent.bottom
  anchors.bottomMargin: 1
  anchors.horizontalCenter: parent.horizontalCenter
  width: parent.width - 10
  height: parent.height - 50
  radius: 20

  color: "transparent"

  required property MprisPlayer player
  property string jumpge: "../Assets/nahidaj.gif"
  property string readge: "../Assets/nahidar.gif"
  property string lewdge: "../Assets/nahidal.gif"

  Connections {
    target: root.player
    function onIsPlayingChanged() {
      const currentge = root.player.isPlaying ? root.jumpge : root.readge;
      gif.source = "";
      gif.source = currentge;
      gif.playing = true;
    }
  }

  AnimatedImage {
    id: gif
    anchors.fill: parent
    anchors.centerIn: parent
    fillMode: Image.PreserveAspectFit
    playing: true
    source: root.player.isPlaying ? root.jumpge : root.readge
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onPressed: {
      gif.source = root.player.isPlaying ? root.jumpge : root.lewdge
      gif.playing = true
    }
    onReleased: {
      gif.source = root.player.isPlaying ? root.jumpge : root.readge
      gif.playing = true
    }
  }
}
