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
        property bool unlockInProgress: false
        property bool showFailure: false
        property string pamMessage: ""
        property string authMode: "auto" // or fingerprint or password
        property int failCount: 0

        onCurrentTextChanged: showFailure = false

        function tryUnlock() {
          lockContext.unlockInProgress = true
          pam.start()
        }

        function fallback() {
          console.log("Fingerprint failed 3 times, fall back to password")
          pam.abort()
          lockContext.authMode = "password"
          failCount = 0
          Qt.callLater(() => pam.start())
        }

        PamContext {
          id: pam

          onPamMessage: {
            lockContext.pamMessage = message

            if (message.toLowerCase().includes("fingerprint")) {
                lockContext.authMode = "fingerprint"
            } else if (message.toLowerCase().includes("password")) {
                lockContext.authMode = "password"
            }

            if (responseRequired && lockContext.authMode === "password") {
                this.respond(lockContext.currentText)
            }
          }

          onCompleted: result => {
            if (result == PamResult.Success) {
              lock.locked = false
            } else {
              lockContext.showFailure = true

              if (lockContext.authMode === "fingerprint") {
                lockContext.failCount += 1
                if (lockContext.failCount >= 3) {
                  lockContext.fallback()
                  return
                }
              }

              lockContext.currentText = ""
            }

            lockContext.unlockInProgress = false
          }
        }
      }

      WlSessionLock {
        id: lock
        locked: true

        onLockedChanged: if (locked) pam.start()

        WlSessionLockSurface {

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

              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime * 1.5
                easing.type: Easing.Linear
                property: "blur"
                running: lockContext.unlockInProgress
                target: walBlur
                to: 0
              }
            }
          }

          // Woe
          // Button {
          //   text: "LET ME OUT! AAAHHHHH"
          //   anchors.top: parent.top
          //   anchors.right: parent.right
          //   anchors.margins: 20
          //   onClicked: lock.locked = false
          // }

          Label {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
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
            color: lockContext.pamMessage.toLowerCase().includes("swipe") ? "transparent" : Dat.Colors.background
            border.color: lockContext.pamMessage.toLowerCase().includes("swipe") ? "transparent" : Dat.Colors.blue
            border.width: 2
            opacity: 0.95
            focus: true

            Keys.onPressed: kevent => {
              if (pam.active) return

              if (kevent.key === Qt.Key_Enter || kevent.key === Qt.Key_Return) {
                lockContext.authMode = "password"
                Qt.callLater(() => lockContext.tryUnlock())
                return
              }

              if (kevent.key === Qt.Key_Backspace) {
                if (kevent.modifiers & Qt.ControlModifier) {
                  lockContext.currentText = ""
                  return
                }
                lockContext.currentText = lockContext.currentText.slice(0, -1)
                return
              }

              if (kevent.text) {
                lockContext.currentText += kevent.text
              }
            }

            TextField {
              id: textfield
              anchors.centerIn: parent
              visible: lockContext.authMode === "password"
              background: Rectangle { color: "transparent" }
              color: Dat.Colors.foreground
              focus: lockContext.authMode === "password"
              enabled: !lockContext.unlockInProgress
              echoMode: TextInput.Password
              inputMethodHints: Qt.ImhSensitiveData
              onAccepted: lockContext.tryUnlock()
            }

            Rectangle {
              anchors.centerIn: parent
              visible: lockContext.authMode === "fingerprint"
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
                  running: {
                    if (lockContext.showFailure || lockContext.pamMessage.toLowerCase().includes("again")) {
                      return true;
                    }
                  }
                  alwaysRunToEnd: true

                  ColorAnimation {
                    target: fingerprintIcon
                    property: "color"
                    from: Dat.Colors.foreground
                    to: Dat.Colors.red
                    easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
                    duration: Dat.MaterialEasing.emphasizedDecelTime
                  }

                  ColorAnimation {
                    target: fingerprintIcon
                    property: "color"
                    from: Dat.Colors.red
                    to: Dat.Colors.foreground
                    easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
                    duration: Dat.MaterialEasing.emphasizedAccelTime
                  }
                }
              }
            }

            Label {
              id: pamStatus
              anchors.centerIn: parent
              anchors.verticalCenterOffset: -60
              text: lockContext.showFailure ? "Authentication Failed" : lockContext.pamMessage
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

