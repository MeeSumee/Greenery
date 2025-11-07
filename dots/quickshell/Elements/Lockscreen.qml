pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.Data as Dat

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
              lockContext.currentText = ""
              Qt.callLater(() => pam.start())
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
          Button {
            text: "LET ME OUT! AAAHHHHH"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            onClicked: lock.locked = false
          }

          Label {
            id: clock
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -200
            renderType: Text.NativeRendering
            font.pointSize: 80
            text: Dat.Time.time
            color: Dat.Colors.background
          }

          Rectangle {
            id: region
            anchors.centerIn: parent
            width: 400
            height: 60
            radius: 30
            color: !pam.responseRequired ? "transparent" : Dat.Colors.background
            border.color: !pam.responseRequired ? "transparent" : Dat.Colors.blue
            border.width: 2
            opacity: 0.95
            focus: true

            TextField {
              id: input
              anchors.centerIn: parent
              visible: (pam.responseRequired && !lockContext.showFailure)
              background: Rectangle { color: "transparent" }
              color: Dat.Colors.foreground
              focus: pam.responseRequired
              echoMode: TextInput.Password
              inputMethodHints: Qt.ImhSensitiveData
              onTextChanged: lockContext.currentText = this.text
              onAccepted: {
                if (pam.responseRequired) {
                  pam.respond(lockContext.currentText)
                }
              }

              Connections {
                target: lockContext

                function onCurrentTextChanged() {
                  input.text = lockContext.currentText
                }
              }
            }

            Rectangle {
              anchors.centerIn: parent
              visible: !pam.responseRequired
              width: 60
              height: 60
              radius: 30
              color: Dat.Colors.background

              Dat.MaterialSymbols {
                id: fingerprintIcon
                anchors.centerIn: parent
                icon: "fingerprint"
                color: Dat.Colors.foreground
                font.pointSize: 30

                SequentialAnimation {
                  running: lockContext.pamMessage.toLowerCase().includes("Failed") || lockContext.pamMessage.toLowerCase().includes("again")
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
            }

            Label {
              id: pamStatus
              anchors.centerIn: parent
              anchors.verticalCenterOffset: -60
              text: lockContext.showFailure ? "Authorization Failed" : lockContext.pamMessage
              color: Dat.Colors.background
              font.pointSize: 14
              horizontalAlignment: Text.AlignHCenter
            }
          }
        }
      }
    }
  }
}

