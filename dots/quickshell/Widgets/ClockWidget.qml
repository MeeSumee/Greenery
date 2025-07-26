// ClockWidget.qml
import QtQuick
import "../Data" as Dat

Text {
  color: Dat.Colors.foreground
  text: Time.time
}
