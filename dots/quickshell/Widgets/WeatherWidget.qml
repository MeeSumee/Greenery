import QtQuick.Layouts
import QtQuick
import qs.Data as Dat

GridLayout {
  id: weathergrid
  anchors.margins: 6        
  anchors.fill: parent
  columns: 8

  Text {
    Layout.columnSpan: 8
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

    id: updated
    text: Dat.Weather.area + ", " + Dat.Weather.time[0]
    color: Dat.Colors.foreground
    font.pointSize: 10
  }

  Text {
    Layout.columnSpan: 4
    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    Layout.leftMargin: 8

    id: temp
    text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[0] : Dat.Weather.tempC[0]
    color: Dat.Colors.foreground
    font.pointSize: 50

    Text {
      anchors.left: parent.right

      id: unit
      text: Dat.Weather.useFahrenheit ? "°F" : "°C"
      color: Dat.Colors.foreground
      font.pointSize: 30
    }

    Text {
      anchors.top: parent.bottom

      id: feelstemp
      text: Dat.Weather.useFahrenheit ? Dat.Weather.feelstempF : Dat.Weather.feelstempC
      color: Dat.Colors.foreground
      font.pointSize: 10
    }
  }

  Dat.MaterialSymbols {
    Layout.columnSpan: 4
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    Layout.topMargin: 1.75
    Layout.rightMargin: 8

    id: weathericon
    font.pixelSize: 64
    font.bold: false
    color: Dat.Colors.foreground
    icon: Dat.Weather.icon[0]

    Text {
      anchors.top: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter

      id: desc
      text: Dat.Weather.description
      color: Dat.Colors.foreground
      font.pointSize: 10
    }
  }

  Rectangle {
    color: "transparent"
    Layout.columnSpan: 8
    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
    Layout.fillWidth: true
    implicitHeight: 90
    radius: 20

    GridLayout {
      id: forecast
      anchors.fill: parent
      columns: 8

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[1]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[2]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[3]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[4]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[5]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[6]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[7]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        font.pixelSize: 32
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[8]
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[1] + "°" : Dat.Weather.tempC[1] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[2] + "°" : Dat.Weather.tempC[2] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[3] + "°" : Dat.Weather.tempC[3] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[4] + "°" : Dat.Weather.tempC[4] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[5] + "°" : Dat.Weather.tempC[5] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[6] + "°" : Dat.Weather.tempC[6] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[7] + "°" : Dat.Weather.tempC[7] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
     
        text: Dat.Weather.useFahrenheit ? Dat.Weather.tempF[8] + "°" : Dat.Weather.tempC[8] + "°"
        color: Dat.Colors.foreground
        font.pointSize: 12
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[1]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }


      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[2]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[3]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[4]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[5]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[6]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[7]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }

      Text {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        text: Dat.Weather.time[8]
        color: Dat.Colors.foreground
        font.pointSize: 8
      }
    }
  }
}

