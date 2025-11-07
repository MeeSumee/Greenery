pragma ComponentBehavior: Bound
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // Set Wallpaper Path
  property string wallSrc: Quickshell.env("HOME") + "/.config/background"
  // Enable JP Months for Calendar
  property bool calendarJP: true
  // Enable imperial units (fahrenheit, mph, etc)
  property bool imperial: false 

  IpcHandler {
    function setWallpaper(path: string) {
      path = Qt.resolvedUrl(path);
      root.wallSrc = path;
    }

    target: "config"
  }
}
