pragma ComponentBehavior: Bound

import QtQuick
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
      loader.active = true
    }
  }

  LazyLoader {
    id: loader

    Item {
      Scope {
        id: lockContext

        property string currentText: ""
        property bool unlockInProgress: false
        property bool showFailure: false
        property string pamMessage: ""
        readonly property bool fingerprint: true

        onCurrentTextChanged: showFailure = false

        function tryUnlock() {
          lockContext.unlockInProgress = true
          pam.start()
        }

        PamContext {
          id: pam

          onPamMessage: {
            lockContext.pamMessage = message

            if (responseRequired) {
              this.respond(lockContext.currentText)
            }
          }

          onCompleted: result => {
            if (result == PamResult.Success) {
              lock.locked = false
            } else {
              lockContext.currentText = ""
              lockContext.showFailure = true
            }

            lockContext.unlockInProgress = false
          }
        }
      }

      WlSessionLock {
        id: lock
        locked: true

        WlSessionLockSurface {
          Rectangle {
            anchors.fill: parent
            color: Dat.Colors.comment

            // Woe
            Button {
              text: "LET ME OUT! AAAHHHHH"
              anchors.top: parent.top
              anchors.right: parent.right
              anchors.margins: 20
              onClicked: lock.locked = false
            }

            Label {
              id: clock
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.top: parent.top
              anchors.topMargin: 100
              renderType: Text.NativeRendering
              font.pointSize: 80
              text: Dat.Time.time
            }

            Rectangle {
              anchors.centerIn: parent
              width: 400
              height: 60
              radius: 30
              color: lockContext.unlockInProgress ? Dat.Colors.blue : Dat.Colors.foreground
              border.color: lockContext.showFailure ? Dat.Colors.red : Dat.Colors.foreground
              border.width: 2
              opacity: 0.95
              focus: true

              Behavior on color { 
                ColorAnimation { 
                  duration: 200 
                } 
              }

              Behavior on border.color { 
                ColorAnimation { 
                  duration: 200 
                } 
              }

              Keys.onPressed: kevent => {
                if (pam.active) return

                  if (kevent.key === Qt.Key_Enter || kevent.key === Qt.Key_Return) {
                    lockContext.tryUnlock()
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

              Label {
                id: pamStatus
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -60
                text: lockContext.showFailure ? "Wrong" : (lockContext.pamMessage || "Enter password or use fingerprint")
                color: "white"
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                width: parent.width - 60
              }

              TextField {
                id: textfield
                anchors.fill: parent
                anchors.centerIn: parent
                hoverEnabled: true
                background: Rectangle {
                  anchors.fill: parent
                  color: "transparent"
                }
                focus: true
                enabled: !lockContext.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
              }

              Dat.MaterialSymbols {
                id: fingerprintIcon
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 16
                icon: lockContext.pamMessage.toLowerCase().includes("fingerprint") ? "fingerprint" : "fingerprint_off"
                color: lockContext.showFailure ? Dat.Colors.red : "white"
                font.pointSize: 22
                visible: true
                opacity: lockContext.pamMessage.toLowerCase().includes("fingerprint") ? 1 : 0.4

                Behavior on opacity { 
                  NumberAnimation { 
                    duration: 250 
                  } 
                }
              }
            }
          }
        }
      }
    }
  }
}

