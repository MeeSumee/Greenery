pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.Data as Dat
import qs.Widgets as Wid

Item {
  IpcHandler {
    target: "lockscreen"

    function lock() {
      if (loader.active) {

        // unfuck the loader by force destroy
        loader.active = false
        // delay
        Qt.callLater(() => loader.active = true)
      } else {
        loader.active = true
      }
    }
  }

  LazyLoader {
    id: loader

    Item {
      Component.onCompleted: pam.start()

      Scope {
        id: lockContext

        property string currentText: ""
        property bool showFailure: false
        property string pamMessage: ""

        onCurrentTextChanged: showFailure = false

        function restart() {
          lockContext.showFailure = false
          pam.start()
        }

        PamContext {
          id: pam

          onPamMessage: {
            lockContext.pamMessage = message
          }

          onCompleted: result => {
            if (result == PamResult.Success) {
              lock.locked = false
            } else {
              lockContext.showFailure = true
              Qt.callLater(() => lockContext.restart())
            }
          }
        }
      }

      WlSessionLock {
        id: lock
        locked: true

        onLockedChanged: if (locked) pam.start()

        WlSessionLockSurface {
          id: surface

          // Emergency Rectangle incase background is fucked
          Rectangle {
            anchors.fill: parent
            color: Dat.Colors.background
          }

          Dat.Background {
            id: wallpaper

            anchors.fill: parent
          
            layer.effect: MultiEffect {
              id: walBlur

              autoPaddingEnabled: false
              blurEnabled: true

              NumberAnimation on blur {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.type: Easing.Linear
                from: 0
                to: 0.69
              }
            }
          }

          // Emergency Button for debugging
          // Button {
          //   text: "LET ME OUT! AAAHHHHH"
          //   anchors.top: parent.top
          //   anchors.right: parent.right
          //   anchors.margins: 20
          //   onClicked: lock.locked = false
          // }

          Label {
            id: clock
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -240
            renderType: Text.NativeRendering
            font.pointSize: 80
            text: Dat.Time.time
            color: Dat.Colors.background
          }

          Rectangle {
            id: weather
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -120
            color: "transparent"
            width: clock.contentWidth
            height: 50

            Text {
              anchors.centerIn: parent
              anchors.horizontalCenterOffset: -50
              font.pointSize: 50
              color: Dat.Colors.background
              text: `${Dat.Weather.temp[0]}°`
            }

            Dat.MaterialSymbols {
              anchors.centerIn: parent
              anchors.horizontalCenterOffset: 60
              font.pointSize: 50
              color: Dat.Colors.background
              icon: Dat.Weather.icon[0]
            }
          }

          Rectangle {
            id: region
            anchors.centerIn: parent
            width: pam.responseRequired ? input.contentWidth + 60 : 60
            height: 60
            radius: 30
            color: Dat.Colors.background
            border.color: Dat.Colors.foreground
            border.width: 2
            opacity: 0.95
            focus: true

            SequentialAnimation {
              running: lockContext.showFailure || lockContext.pamMessage.toLowerCase().includes("failed") || lockContext.pamMessage.toLowerCase().includes("again")
              alwaysRunToEnd: true

              ColorAnimation {
                target: region
                property: "border.color"
                from: Dat.Colors.foreground
                to: Dat.Colors.red
                easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
                duration: Dat.MaterialEasing.emphasizedDecelTime * 3
              }

              ColorAnimation {
                target: region
                property: "border.color"
                from: Dat.Colors.red
                to: Dat.Colors.foreground
                easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
                duration: Dat.MaterialEasing.emphasizedAccelTime * 3
              }
            }

            Behavior on width {
              NumberAnimation {
                duration: Dat.MaterialEasing.standardTime
                easing.bezierCurve: Dat.MaterialEasing.standard
              }
            }

            Dat.MaterialSymbols {
              id: fingerprintIcon
              anchors.centerIn: parent
              visible: !pam.responseRequired
              icon: "fingerprint"
              color: Dat.Colors.foreground
              font.pointSize: 30

              SequentialAnimation {
                running: lockContext.showFailure || lockContext.pamMessage.toLowerCase().includes("failed") || lockContext.pamMessage.toLowerCase().includes("again")
                alwaysRunToEnd: true

                ColorAnimation {
                  target: fingerprintIcon
                  property: "color"
                  from: Dat.Colors.foreground
                  to: Dat.Colors.red
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
                  duration: Dat.MaterialEasing.emphasizedDecelTime * 3
                }

                ColorAnimation {
                  target: fingerprintIcon
                  property: "color"
                  from: Dat.Colors.red
                  to: Dat.Colors.foreground
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
                  duration: Dat.MaterialEasing.emphasizedAccelTime * 3
                }
              }
            }

            TextField {
              id: input
              anchors.centerIn: parent
              visible: (pam.responseRequired && !lockContext.showFailure)
              background: Rectangle { color: "transparent" }
              color: Dat.Colors.foreground
              focus: pam.responseRequired
              echoMode: TextInput.Password
              font.pointSize: 20
              inputMethodHints: Qt.ImhSensitiveData
              onTextChanged: lockContext.currentText = this.text
              onAccepted: {
                if (pam.responseRequired) {
                  pam.respond(lockContext.currentText)
                  this.clear()
                }
              }

              Connections {
                target: lockContext

                function onCurrentTextChanged() {
                  input.text = lockContext.currentText
                }
              }
            }
          }
        }
      }
    }
  }
}

