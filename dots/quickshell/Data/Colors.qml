pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color background:"#FA232136"
    readonly property color foreground:"#ebbcba"

    function withAlpha(color: color, alpha: real): color {
      return Qt.rgba(color.r, color.g, color.b, alpha);
  }
}