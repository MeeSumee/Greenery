import QtQuick
import QtQuick.Layouts
import qs.Widgets as Wid
import qs.Data as Dat
import qs.Panels as Pan

Rectangle {
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.margins: 1
  y: 27
  color: Dat.Colors.background
  radius: 25
  id: barpanel
  implicitHeight: 370
  implicitWidth: 1000

  // Buttons
  Item {
    anchors.left: parent.left
    implicitHeight: parent.implicitHeight
    implicitWidth: 61.5

    ColumnLayout {
      id: menulist

      anchors.fill: parent
      spacing: 0

      Rectangle {
        id: button1
        radius: 30

        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        Layout.margins: 4

        implicitHeight: parent.implicitHeight / 7

        color: "transparent"

        Dat.MaterialSymbols {
          anchors.centerIn: parent
          font.pixelSize: (content.currentIndex == 0) ? 40:25

          // Behavior on font.pixelSize {
          //   NumberAnimation {
          //     duration: Dat.MaterialEasing.standardAccelTime
          //     easing.bezierCurve: Dat.MaterialEasing.standardAccel
          //   }
          // }

          font.bold: false
          color: Dat.Colors.foreground
          icon: "home"

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: content.currentIndex = 0
          }
        }
      }

      Rectangle {
        id: button2
        radius: 30

        Layout.fillWidth: true
        Layout.margins: 4
        Layout.alignment: Qt.AlignBottom

        implicitHeight: parent.implicitHeight / 7

        color: "transparent"
          
        Dat.MaterialSymbols {
          anchors.centerIn: parent
          font.pixelSize: (content.currentIndex == 1) ? 40:25

          // Behavior on font.pixelSize {
          //   NumberAnimation {
          //     duration: Dat.MaterialEasing.standardAccelTime
          //     easing.bezierCurve: Dat.MaterialEasing.standardAccel
          //   }
          // }

          font.bold: false
          color: Dat.Colors.foreground
          icon: "music_note"

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: content.currentIndex = 1
          }
        }              
      }

      Rectangle {
        id: button3
        radius: 30

        Layout.fillWidth: true
        Layout.margins: 4
        Layout.alignment: Qt.AlignBottom

        implicitHeight: parent.implicitHeight / 7

        color: "transparent"
          
        Dat.MaterialSymbols {
          anchors.centerIn: parent
          font.pixelSize: (content.currentIndex == 2) ? 40:25

          // Behavior on font.pixelSize {
          //   NumberAnimation {
          //     duration: Dat.MaterialEasing.standardAccelTime
          //     easing.bezierCurve: Dat.MaterialEasing.standardAccel
          //   }
          // }

          font.bold: false
          color: Dat.Colors.foreground
          icon: "notifications"

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: content.currentIndex = 2
          }
        }   
      }

      Rectangle {
        id: button4
        radius: 30

        Layout.fillWidth: true
        Layout.margins: 4
        Layout.alignment: Qt.AlignBottom

        implicitHeight: parent.implicitHeight / 7

        color: "transparent"
          
        Dat.MaterialSymbols {
          anchors.centerIn: parent
          font.pixelSize: (content.currentIndex == 3) ? 40:25

          // Behavior on font.pixelSize {
          //   NumberAnimation {
          //     duration: Dat.MaterialEasing.standardAccelTime
          //     easing.bezierCurve: Dat.MaterialEasing.standardAccel
          //   }
          // }

          font.bold: false
          color: Dat.Colors.foreground
          icon: "speed"

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: content.currentIndex = 3
          }
        }   
      }

      Rectangle {
        id: button5
        radius: 30

        Layout.fillWidth: true
        Layout.margins: 4
        Layout.alignment: Qt.AlignBottom

        implicitHeight: parent.implicitHeight / 7

        color: "transparent"
          
        Wid.Logo {
          anchors.centerIn: parent
          implicitHeight: (content.currentIndex == 4) ? 40:25
          implicitWidth: (content.currentIndex == 4) ? 40:25

          Behavior on implicitHeight {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardAccelTime
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
            }
          }

          Behavior on implicitWidth {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardAccelTime
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
            }
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: content.currentIndex = 4
          }
        }   
      }

      Rectangle {
        id: button6
        radius: 30

        Layout.fillWidth: true
        Layout.margins: 5
        Layout.alignment: Qt.AlignBottom

        implicitHeight: parent.implicitHeight / 7

        color: "transparent"
          
        Dat.MaterialSymbols {
          anchors.centerIn: parent
          font.pixelSize: (content.currentIndex == 5) ? 40:25

          // Behavior on font.pixelSize {
          //   NumberAnimation {
          //     duration: Dat.MaterialEasing.standardAccelTime
          //     easing.bezierCurve: Dat.MaterialEasing.standardAccel
          //   }
          // }

          font.bold: false
          color: Dat.Colors.foreground
          icon: "manufacturing"

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: content.currentIndex = 5
          }
        }  
      }
    }
  }

  // Content
  Item {
    anchors.margins: 10        
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: parent.implicitHeight
    implicitWidth: 930.5

    StackLayout {
      id: content
      anchors.fill: parent

      Pan.Dashboard {
        opacity: visible ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }
      }

      Pan.Media {
        opacity: visible ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }
      }

      Pan.Notifications {
        opacity: visible ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }
      }

      Pan.Performance {
        opacity: visible ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }
      }

      Pan.System {
        opacity: visible ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }
      }

      Pan.Settings {
        opacity: visible ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }
      }
    }
  }
}
