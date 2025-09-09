import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Widgets as Wid
import qs.Data as Dat
import qs.Panels as Pan

WlrLayershell {
    id: bar

    required property ShellScreen modelData

    anchors.top: true
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    implicitHeight: screen.height * 0.39
    implicitWidth: screen.width * 0.61
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

        color: Dat.Colors.withAlpha(Dat.Colors.background, 0.80)
        anchors.horizontalCenter: parent.horizontalCenter
        bottomLeftRadius: 25
        bottomRightRadius: 25
        clip: true
        state: barfull.state = (barfull.actWinName == "desktop") ? "SHOWN" : "HIDDEN"

        MouseArea {
            id: barArea
            anchors.top: parent.top
            height: 30
            width: parent.width

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
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 1
                Layout.leftMargin: 3

                Wid.Logo {
                    Layout.alignment: Qt.AlignTop
                    implicitHeight: 25
                    implicitWidth: 25
                }
            }

            // Apparently adding horizontalCenter twice stops the jittering of ClockWidget, but appears as warning
            Item {
                Layout.fillHeight: true
                Layout.topMargin: 3
                anchors.horizontalCenter: parent.horizontalCenter

                Wid.ClockWidget {
                  anchors.horizontalCenter: parent.horizontalCenter
                }

                Pan.Panel {}
            }

            Item {
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: 1

                Wid.Battery {
                  Layout.alignment:Qt.AlignTop                 
                  implicitWidth: 25
                  implicitHeight: 25
                }
            }
        }

        states: [
            State {
                name: "HIDDEN"
                PropertyChanges {
                    barfull.opacity: 0
                    barfull.height: barfull.hiddenHeight
                    barfull.width: barfull.hiddenWidth
                }
            },
            State {
                name: "SHOWN"
                PropertyChanges {
                    barfull.opacity: 1
                    barfull.height: barfull.shownHeight
                    barfull.width: barfull.shownWidth
                }
            },
            State {
                name: "FULL"
                PropertyChanges {
                    barfull.opacity: 1
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
