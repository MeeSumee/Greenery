import QtQuick
import QtQuick.Controls
import QtQuick.Effects

import "../Data" as Dat
import "../Data/Khal.qml" as CalendarService

Column {
    id: calendarGrid

    property date displayDate: new Date()

    spacing: 5

    // Month navigation header
    Row {
        width: parent.width
        height: 40

        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "←"
                font.pointSize: 18
                color: Dat.Colors.foreground
            }

            MouseArea {
                id: prevMonthArea

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    let newDate = new Date(displayDate);
                    newDate.setMonth(newDate.getMonth() - 1);
                    displayDate = newDate;
                }
            }

        }

        Text {
            width: parent.width - 80
            height: 40
            text: Qt.formatDate(displayDate, "MMMM yyyy")
            font.pointSize: 11
            color: Dat.Colors.foreground
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "→"
                font.pointSize: 18
                color: Dat.Colors.foreground
            }

            MouseArea {
                id: nextMonthArea

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    let newDate = new Date(displayDate);
                    newDate.setMonth(newDate.getMonth() + 1);
                    displayDate = newDate;
                }
            }

        }

    }

    // Days of week header
    Row {
        width: parent.width
        height: 32

        Repeater {
            model: ["日", "月", "火", "水", "木", "金", "土"]

            Rectangle {
                width: parent.width / 7
                height: 32
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: modelData
                    font.pointSize: 11
                    color: Dat.Colors.foreground
                }

            }

        }

    }

    // Calendar grid
    Grid {
        property date firstDay: {
            let date = new Date(displayDate.getFullYear(), displayDate.getMonth(), 1);
            let dayOfWeek = date.getDay();
            date.setDate(date.getDate() - dayOfWeek);
            return date;
        }

        width: parent.width
        height: 245 // Fixed height for calendar
        columns: 7
        rows: 6

        Repeater {
            model: 42

            Rectangle {
                property date dayDate: {
                    let date = new Date(parent.firstDay);
                    date.setDate(date.getDate() + index);
                    return date;
                }
                property bool isCurrentMonth: dayDate.getMonth() === displayDate.getMonth()
                property bool isToday: dayDate.toDateString() === new Date().toDateString()

                width: parent.width / 7
                height: (parent.height + 8) / 6
                color: "transparent"
                clip: true

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 4
                    height: parent.height - 4
                    color: "transparent"
                    radius: 20
                    clip: true

                    Text {
                        anchors.centerIn: parent
                        text: dayDate.getDate()
                        color: Dat.Colors.foreground
                        font.pointSize: 11
                    }

                    // Highlight Today's Date
                    Rectangle {
                        id: eventIndicator

                        anchors.fill: parent
                        radius: parent.radius
                        visible: CalendarService && CalendarService.khalAvailable
                        opacity: {
                            if (isToday)
                                return 0.25;
                            else
                                return 0;
                        }

                    }

                }

            }

        }

    }

}
