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
	color: "transparent"
	exclusionMode: ExclusionMode.Ignore
	focusable: false
	implicitHeight: screen.height * 0.4
    implicitWidth: screen.width
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

		readonly property int idleWidth: 20
		readonly property int drawWidth: 400

		height: 400
		color: Dat.Colors.withAlpha(Dat.Colors.background, 0.9)
		bottomRightRadius: 25; topRightRadius: 25
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
					appshow.width: appshow.idleWidth
				}
			},
			State {
				name: "DRAW";
				PropertyChanges {
					appshow.opacity: 1
					appshow.width: appshow.drawWidth
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
							properties: "opacity, width"
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
							properties: "opacity, width"
							easing.bezierCurve: Dat.MaterialEasing.standardAccel
                            duration: 150
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