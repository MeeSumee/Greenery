pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // dracula palette
    readonly property color background:"#282A36"
    // readonly property color foreground:"#F8F8F2"
    // foreground custom
    readonly property color foreground: "#BD93F9"
    readonly property color selection: "#44475A"
    readonly property color comment: "#6272A4"
    readonly property color red: "#FF5555"
    readonly property color orange: "#FFB86C"
    readonly property color yellow: "#F1FA8C"
    readonly property color green: "#50FA7B"
    readonly property color purple: "#BD93F9"
    readonly property color cyan: "#8BE9FD"
    readonly property color pink: "#FF79C6"
    readonly property color bright_red: "#FF6E6E"
    readonly property color bright_green: "#69FF94"
    readonly property color bright_yellow: "#FFFFA5"
    readonly property color bright_blue: "#D6ACFF"
    readonly property color bright_magenta: "#FF92DF"
    readonly property color bright_cyan: "#A4FFFF"
    readonly property color bright_white: "#FFFFFF"
    readonly property color menu: "#21222C"
    readonly property color visual: "#3E4452"
    readonly property color gutter_fg: "#4B5263"
    readonly property color nontext: "#3B4048"
    readonly property color white: "#ABB2BF"
    readonly property color black: "#191A21"

    function withAlpha(color: color, alpha: real): color {
      return Qt.rgba(color.r, color.g, color.b, alpha);
  }
}
