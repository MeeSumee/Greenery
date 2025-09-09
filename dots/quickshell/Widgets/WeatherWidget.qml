import QtQuick.Layouts
import QtQuick
import qs.Data as Dat

GridLayout {
  id: weathergrid
  anchors.margins: 6        
  anchors.fill: parent
  columns: 4
  rowSpacing: 5

  Rectangle {
    Layout.columnSpan: 4
    implicitHeight: parent.implicitHeight / 5

    Dat.MaterialSymbols {
      id: icon
      Layout.alignment: Qt.AlignLeft | Qt.AlignTop

      text: Dat.Weather.icon[0]
      color: Dat.Colors.foreground
      font.pointSize: 48
    }
  }

  Rectangle {
    Layout.columnSpan: 4
    implicitHeight: parent.implicitHeight / 5
    Text {
      id: desc
      Layout.alignment: icon.Qt.AlignBottom

      text: Dat.Weather.description
      color: Dat.Colors.foreground
      font.pointSize: 24
    }
  }

  Rectangle {
    Layout.columnSpan: 4
    implicitHeight: parent.implicitHeight / 5
    Text {
      id: temp
      Layout.alignment: Qt.AlignLeft
      text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[0] : Dat.Weather.tempC[0]
      color: Dat.Colors.foreground
      font.pointSize: 24
    }
  }
}

