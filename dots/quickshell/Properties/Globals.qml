pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import "../Data/" as Dat

Singleton {
  id: root

  property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"

  onActWinNameChanged: {
    if (root.actWinName == "desktop" && root.notchState == "COLLAPSED") {
      root.notchState = "EXPANDED";
    } 
  }
}
