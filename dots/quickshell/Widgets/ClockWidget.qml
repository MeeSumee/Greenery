// ClockWidget.qml
import QtQuick
import "../Data" as Dat

Text {
  font.pointSize: 15
  color: Dat.Colors.foreground
  text: Dat.Time.time
}
