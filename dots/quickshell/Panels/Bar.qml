import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import "../Widgets" as Wid
import "../Data" as Dat

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
				color: Dat.Colors.background
        		anchors.horizontalCenter: parent.horizontalCenter

        		width: 300; height:10
				bottomLeftRadius: 25; bottomRightRadius: 25
        		state: "HIDDEN"
        		opacity: 0

        	    RowLayout {
        	    	anchors.fill: parent
        	    	// Left
					Item {
						Layout.fillHeight: true
						Layout.fillWidth: true
						RowLayout {
							anchors.left: parent.left
							anchors.verticalCenter: parent.verticalCenter
							anchors.top: parent.top
		        	    	Wid.Logo {
		        	    		Layout.alignment: Qt.AlignTop
		        	    	    Layout.maximumHeight: 30
		        	    	    Layout.maximumWidth: 30
		        	    	}
		        	    }
        	    	}
        	    	// Center
        	    	Item {
						Layout.fillHeight: true
						Layout.fillWidth: true
						Layout.topMargin: 8
						Wid.ClockWidget {
							anchors.horizontalCenter: parent.horizontalCenter
		      			}
	      			}
	      			// Right
	      			Item {
	      				Layout.fillHeight: true
	      				Layout.fillWidth: true
	      				RowLayout {
	      					anchors.right: parent.right
	      					anchors.verticalCenter: parent.verticalCenter
	      					anchors.top: parent.top
		        	    	Wid.Battery {
								Layout.alignment: Qt.AlignTop
								Layout.topMargin: 15
		        	    	}
		        	    }
        	    	}
           		}

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
            			PropertyChanges { target: barfull; height: 30; width: 1000; opacity: 0.98; }
            		},
            		State {
            			name: "FULL";
            			PropertyChanges { target: barfull; height: 400; width: 1000; opacity: 0.98; }
            		}
                ]

                transitions: [
                    Transition {
                        from: "HIDDEN"; to: "SHOWN";

                        NumberAnimation {
                            properties: "height, width, opacity";
                            easing.type: Easing.InOutQuad;
                            duration: 300;
                        }
                    },
                    Transition {
                        from: "SHOWN"; to: "FULL";

                        NumberAnimation {
                            properties: "height, width, opacity";
                            easing.type: Easing.InOutQuad;
                            duration: 300;
                        }
                    },
                    Transition {
                        from: "FULL"; to: "SHOWN";

                        NumberAnimation {
                            easing.type: Easing.InOutQuad;
                            properties: "height, width, opacity";
                            duration: 300;
                        }
                    },
                    Transition {
                        from: "FULL"; to: "HIDDEN";

                        NumberAnimation {
                            easing.type: Easing.InOutQuad;
                            properties: "height, width, opacity";
                            duration: 300;
                        }
                    },
                    Transition {
                        from: "SHOWN"; to: "HIDDEN";

                        NumberAnimation {
                            easing.type: Easing.InOutQuad;
                            properties: "height, width, opacity";
                            duration: 300;
                        }
                    }
                ]
            }
		}
	}
}
