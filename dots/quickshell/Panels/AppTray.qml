import QtQuick
import QtQuick.Controls
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

	Keys.onEscapePressed: {
		appshow.state = "IDLE"
	}

	Keys.onPressed: function(event) {
		var key = event.text
		if (event.key == Qt.Key_Meta && Qt.Key_D) {
			appshow.state = "DRAW"
		}
		else {
			appshow.state = "IDLE"
		}
	}

	Rectangle {
		id: appshow

		readonly property int idleWidth: 5
		readonly property int drawWidth: 400
		readonly property int idleX: 0
		readonly property int drawX: (screen.width - drawWidth) / 2
		readonly property int withdrawX: screen.width

		height: 400
		color: Dat.Colors.withAlpha(Dat.Colors.background, 1)
		border {
			width: 1
			color: Dat.Colors.foreground
		}
		radius: 25
		clip: true
		state: "IDLE"

		MouseArea {
			id: appArea
			anchors.fill: parent

			hoverEnabled: true
			preventStealing: true

			onEntered: appshow.state = (appshow.state !== "DRAW") ? "DRAW" : "IDLE"
		}

		states: [
			State {
				name: "IDLE";
				PropertyChanges {
					appshow.opacity: 0
					appshow.width: appshow.idleWidth
					appshow.x: appshow.idleX
				}
			},
			State {
				name: "DRAW";
				PropertyChanges {
					appshow.opacity: 1
					appshow.width: appshow.drawWidth
					appshow.x: appshow.drawX
				}
			}
		]
		
		transitions: [
			Transition {
				from: "IDLE"
				to: "DRAW"

				SequentialAnimation {

					ParallelAnimation {
						NumberAnimation {
							properties: "opacity, width, x"
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
							properties: "opacity, width, x"
							easing.bezierCurve: Dat.MaterialEasing.standardAccel
                            duration: 150
							target: appshow
						}
					}
				}
			}
		]
	}
}