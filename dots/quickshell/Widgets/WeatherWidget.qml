import QtQuick.Layouts
import QtQuick
import qs.Data as Dat

GridLayout {
  id: weathergrid
  anchors.margins: 5       
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
    Layout.alignment: Qt.AlignRight | Qt.AlignTop
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
      height: 80
      width: 80

      id: desc
      text: Dat.Weather.description
      color: Dat.Colors.foreground
      font.pointSize: 10
      horizontalAlignment: Text.AlignHCenter
      wrapMode: Text.WordWrap
    }
  }

  Item {
    Layout.columnSpan: 8
    Layout.alignment: Qt.AlignTop
    Layout.fillWidth: true
    implicitHeight: 100

    Canvas {
      id: tempgraph
      antialiasing: true
      anchors.fill: parent
      renderStrategy: Canvas.Cooperative

      onPaint: {
        if (Dat.Weather.tempC[0] != "??") {
          const ctx = getContext("2d")
          ctx.reset()
          ctx.clearRect(0, 0, width, height)

          const count = Dat.Weather.tempC.length - 1
          if (count < 2)
            return

          // Compute ranges
          const maxTemp = Dat.Weather.useFahrenheit ? Math.max(...Dat.Weather.tempF) : Math.max(...Dat.Weather.tempC)
          const minTemp = Dat.Weather.useFahrenheit ? Math.min(...Dat.Weather.tempF) : Math.min(...Dat.Weather.tempC)
          const range = maxTemp - minTemp || 1

          const padding = 20
          const xStep = (width - 2 * padding) / (count - 1)

          // Y mapping: higher temps → higher on graph
          function tempToY(temp) {
            const ratio = (temp - minTemp) / range
            return height - padding - ratio * (height - 2 * padding)
          }

          // Draw line path
          ctx.beginPath()
          ctx.strokeStyle = Dat.Colors.foreground
          ctx.lineWidth = 2
          ctx.moveTo(padding, tempToY(Dat.Weather.useFahrenheit ? Dat.Weather.tempF[1] : Dat.Weather.tempC[1]))

          for (let i = 1; i < count; i++) {
            ctx.lineTo(padding + i * xStep, tempToY(Dat.Weather.useFahrenheit ? Dat.Weather.tempF[i+1] : Dat.Weather.tempC[i+1]))
          }
          ctx.stroke()

          // Draw points and temperature labels
          ctx.fillStyle = Dat.Colors.foreground
          ctx.font = "14px sans-serif"
          ctx.textAlign = "center"
          ctx.textBaseline = "bottom"
          for (let i = 0; i < count; i++) {
            const x = padding + i * xStep
            const y = tempToY(Dat.Weather.useFahrenheit ? Dat.Weather.tempF[i+1] : Dat.Weather.tempC[i+1])
            ctx.beginPath()
            ctx.arc(x, y, 3, 0, Math.PI * 2)
            ctx.fill()

            const label = Dat.Weather.useFahrenheit ? Dat.Weather.tempF[i+1] + "°" : Dat.Weather.tempC[i+1] + "°"
            const xOffset = i % 2 === 0 ? 4 : 0
            ctx.fillText(label, x + xOffset, y - 6)
          }
        }
      }
      Connections {
        target: Dat.Weather
        function onWeatherReady() {
          tempgraph.requestPaint()
        }
      }
    }
  }


  Rectangle {
    color: "transparent"
    Layout.columnSpan: 8
    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
    Layout.fillWidth: true
    implicitHeight: 40
    radius: 20

    GridLayout {
      id: forecast
      anchors.fill: parent
      anchors.margins: 5
      columns: 8

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[1]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[2]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[3]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[4]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[5]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[6]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[7]
      }

      Dat.MaterialSymbols {
        Layout.columnSpan: 1
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        font.pixelSize: 28
        font.bold: false
        color: Dat.Colors.foreground
        icon: Dat.Weather.icon[8]
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

