import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import qs.Widgets as Wid
import qs.Data as Dat
import qs.Panels as Pan

WlrLayershell {
	id: apptray

	required property ShellScreen modelData

	anchors.left: true
	anchors.right: true
	anchors.bottom: true
	color: "transparent"
	exclusionMode: ExclusionMode.Ignore
	focusable: false
	implicitHeight: screen.height * 0.5
	layer: WlrLayer.Top
	namespace: "sumee.apptray.quickshell"
	screen: modelData
	surfaceFormat.opaque: false

	mask: Region {
		Region {
			item: appshow
		}
	}

	Rectangle {
		id: appshow

		readonly property int idleHeight: 20
		readonly property int drawHeight: 500

		width: 500
		color: Dat.Colors.withAlpha(Dat.Colors.background, 0.9)
		anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
		topLeftRadius: 25; topRightRadius: 25
		clip: true
		state: "IDLE"

		MouseArea {
			id: appArea
			anchors.fill: parent

			hoverEnabled: true
			preventStealing: true

			onExited: appshow.state = "IDLE"
			onEntered: appshow.state = "DRAW"
		}

        Item {
            Shortcut {
            context: Qt.ApplicationShortcut
            sequences: [StandardKey.Close, "Ctrl+D"]

                onActivated: {
                    appshow.state = (appshow.state !== "DRAW") ? "DRAW" : "IDLE"
                    console.log("Activated")
                }
            }
        }

		states: [
			State {
				name: "IDLE";
				PropertyChanges {
					appshow.opacity: 0
					appshow.height: appshow.idleHeight
				}
			},
			State {
				name: "DRAW";
				PropertyChanges {
					appshow.opacity: 1
					appshow.height: appshow.drawHeight
				}
			}
		]
		
		transitions: [
			Transition {
				from: "IDLE"
				to: "DRAW"

				SequentialAnimation {
					
					PropertyAction {
						property: "opacity"
						target: appshow
					}

					ParallelAnimation {
						NumberAnimation {
							properties: "opacity, height"
							easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
							target: appshow
						}
					}
				}
			},

			Transition {
				from: "DRAW"
				to: "IDLE"

				SequentialAnimation {

					ParallelAnimation {
						NumberAnimation {
							properties: "opacity, height"
							easing.bezierCurve: Dat.MaterialEasing.emphasized
							target: appshow
						}
					}
                    
                    PropertyAction {
						property: "opacity"
						target: appshow
					}
				}
			}
		]
	}
}