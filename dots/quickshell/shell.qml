import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "Widgets"

Scope {
	Variants {
		model: Quickshell.screens

		delegate: WlrLayershell {
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
        		anchors.horizontalCenter: parent.horizontalCenter

				ClockWidget {
            		anchors.centerIn: parent
      			}

            	width: 100; height:1
            	state: "HIDDEN"

            	MouseArea {
            		id: mouseArea
            		anchors.fill: parent
            		hoverEnabled: true
            		onExited: barfull.state = "HIDDEN"
            		onEntered: barfull.state = "SHOWN"
            		onClicked: barfull.state = "FULL"
            	}

            	states: [
            	    State {
            	    	name: "HIDDEN";
            	    	PropertyChanges { target: barfull; }
            	    },
            		State {
            			name: "SHOWN";
            			PropertyChanges { target: barfull; height: 30; width: 1000 }
            		},
            		State {
            			name: "FULL";
            			PropertyChanges { target: barfull; height: 400; width: 1000 }
            		}
                ]

                transitions: [
                    Transition {
                        from: "HIDDEN"; to: "SHOWN";

                        NumberAnimation {
                            properties: "height, width";
                            easing.type: Easing.InOutQuad;
                            duration: 100;
                        }
                    },
                    Transition {
                        from: "SHOWN"; to: "FULL";

                        NumberAnimation {
                            properties: "height, width";
                            easing.type: Easing.InOutQuad;
                            duration: 250;
                        }
                    },
                    Transition {
                        from: "FULL"; to: "HIDDEN";

                        NumberAnimation {
                            easing.type: Easing.InOutQuad;
                            properties: "height, width";
                            duration: 250;
                        }
                    },
                    Transition {
                        from: "SHOWN"; to: "HIDDEN";

                        NumberAnimation {
                            easing.type: Easing.InOutQuad;
                            properties: "height, width";
                            duration: 100;
                        }
                    }
                ]
            }
		}
	}
}
