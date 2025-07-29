import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import "../Widgets" as Wid
import "../Data" as Dat
import "../Properties" as Prop
import "../Panels" as Pan

WlrLayershell {
	id: bar

	required property ShellScreen modelData

	anchors.left: true
	anchors.right: true
	anchors.top: true
	color: "transparent"
	exclusionMode: ExclusionMode.Ignore
	focusable: false
	implicitHeight: screen.height * 0.65
	layer: WlrLayer.Top
	namespace: "sumee.bar.quickshell"
	screen: modelData
	surfaceFormat.opaque: false

	mask: Region {
		Region {
			item: barfull
		}
	}

	Rectangle {
		id: barfull

		property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"
		readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
		readonly property int hiddenHeight: 1
		readonly property int hiddenWidth: 500
		readonly property int shownHeight: 30
		readonly property int shownWidth: 1000
		readonly property int fullHeight: 400
		readonly property int fullWidth: this.shownWidth

		color: Dat.Colors.background
		anchors.horizontalCenter: parent.horizontalCenter
		bottomLeftRadius: 25; bottomRightRadius: 25
		clip: true
		state: barfull.state = (barfull.actWinName == "desktop") ? "SHOWN" : "HIDDEN"	

		MouseArea {
			id: barArea
			anchors.top: parent.top
			height: 30
			width: 1000

			hoverEnabled: true
			preventStealing: true

			onExited: barfull.state = (barfull.state == "FULL") ? "FULL" : "HIDDEN"
			onEntered: barfull.state = (barfull.state == "FULL") ? "FULL" : "SHOWN"
			onClicked: barfull.state = (barfull.state !== "FULL") ? "FULL" : "SHOWN"
		}

		RowLayout {
			anchors.fill: parent

			Item {
				Layout.fillHeight: true
				Layout.fillWidth: true

				Wid.Logo {
					Layout.alignment: Qt.AlignTop
				}
			}

			Item {
				Layout.fillHeight: true
				Layout.fillWidth: true
				Layout.topMargin: 5
				anchors.horizontalCenter: parent.horizontalCenter

				Wid.ClockWidget {
					anchors.horizontalCenter: parent.horizontalCenter
				} 

				Pan.Panel {
					
				}
			}

			Item {
				Layout.fillHeight: true
				Layout.fillWidth: true
				Layout.topMargin: 5
				anchors.right:parent.right

				Wid.Battery {
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		}

		states: [
			State {
				name: "HIDDEN";
				PropertyChanges {
					barfull.opacity: 0
					barfull.height: barfull.hiddenHeight
					barfull.width: barfull.hiddenWidth
				}
			},
			State {
				name: "SHOWN";
				PropertyChanges { 
					barfull.opacity: 0.98
					barfull.height: barfull.shownHeight
					barfull.width: barfull.shownWidth
				}
			},
			State {
				name: "FULL";
				PropertyChanges { 
					barfull.opacity: 0.98
					barfull.height: barfull.fullHeight
					barfull.width: barfull.fullWidth
				}
			}
		]
		
		transitions: [
			Transition {
				from: "HIDDEN"
				to: "SHOWN"

				SequentialAnimation {
					
					PropertyAction {
						property: "opacity"
						target: barfull
					}

					ParallelAnimation {
						NumberAnimation {
							properties: "opacity, width, height"
							easing.bezierCurve: Dat.MaterialEasing.emphasized
							target: barfull
							duration: 400
						}
					}
				}
			},

			Transition {
				from: "SHOWN"
				to: "FULL"

				SequentialAnimation {
					
					PropertyAction {
						property: "opacity"
						target: barfull
					}

					ParallelAnimation {
						NumberAnimation {
							properties: "opacity, width, height"
							easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
							target: barfull
						}
					}
				}
			},

			Transition {
				from: "FULL"
				to: "SHOWN"

				SequentialAnimation {
					
					PropertyAction {
						property: "opacity"
						target: barfull
					}

					ParallelAnimation {
						NumberAnimation {
							properties: "opacity, width, height"
							easing.bezierCurve: Dat.MaterialEasing.emphasized
							target: barfull
						}
					}
				}
			},

			Transition {
				from: "FULL"
				to: "HIDDEN"

				SequentialAnimation {

					ParallelAnimation {
						NumberAnimation {
							properties: "opacity, width, height"
							easing.bezierCurve: Dat.MaterialEasing.emphasized
							target: barfull
							duration: 700
						}
					}

					PropertyAction {
						property: "opacity"
						target: barfull
					}
				}
			},

			Transition {
				from: "SHOWN"
				to: "HIDDEN"

				SequentialAnimation {

					ParallelAnimation {

						NumberAnimation {
							properties: "opacity, width, height"
							easing.bezierCurve: Dat.MaterialEasing.emphasized
							target: barfull
							duration: 700
						}
					}
					
					PropertyAction {
						property: "opacity"
						target: barfull
					}
				}
			}
		]
	}
}
