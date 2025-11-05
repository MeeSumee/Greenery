import QtQuick
import qs.Data as Dat

Column {
  id: calendarGrid
  width: parent.width

  property date displayDate: new Date()
  property bool japenis: true

  spacing: 5

  // Check to see if the date is the same, rerun the loader otherwise
  function isSameDay(d1, d2) {
    return d1.getFullYear() === d2.getFullYear()
    && d1.getMonth() === d2.getMonth()
    && d1.getDate() === d2.getDate();
  }

  // Month navigation header
  Row {
    width: parent.width
    height: 40

    Rectangle {
      width: 40
      height: 40
      radius: 20
      color: "transparent"

      Dat.MaterialSymbols {
        id: prevArrow
        anchors.centerIn: parent
        font.pixelSize: 30
        font.bold: false
        color: prevMonthArea.containsMouse ? Dat.Colors.blue : Dat.Colors.foreground
        opacity: 1
        icon: "arrow_circle_left"

        Behavior on color {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }

        MouseArea {
          id: prevMonthArea

          anchors.fill: parent
          hoverEnabled: true
          onClicked: {
            let newDate = new Date(calendarGrid.displayDate);
            newDate.setMonth(newDate.getMonth() - 1);
            calendarGrid.displayDate = newDate;
          }
        }
      }
    }

    Text {
      width: parent.width - 80
      height: 40
      text: Qt.formatDate(calendarGrid.displayDate, "MMMM yyyy")
      font.pointSize: 18
      color: Dat.Colors.foreground
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
      width: 40
      height: 40
      radius: 20
      color: "transparent"

      Dat.MaterialSymbols {
        id: nextArrow
        anchors.centerIn: parent
        font.pixelSize: 30
        font.bold: false
        color: nextMonthArea.containsMouse ? Dat.Colors.blue : Dat.Colors.foreground
        icon: "arrow_circle_right"

        Behavior on color {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }

        MouseArea {
          id: nextMonthArea

          anchors.fill: parent
          hoverEnabled: true
          onClicked: {
            let newDate = new Date(calendarGrid.displayDate);
            newDate.setMonth(newDate.getMonth() + 1);
            calendarGrid.displayDate = newDate;
          }
        }
      }
    }
  }

  // Days of week header
  Row {
    width: parent.width
    height: 32

    Repeater {
      model: calendarGrid.japenis ? ["日", "月", "火", "水", "木", "金", "土"] : ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

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

  // Calendar Grid Loader
  Loader {
    id: loader
    width: parent.width
    active: true

    sourceComponent: Grid {
      property date firstDay: {
        let date = new Date(displayDate.getFullYear(), displayDate.getMonth(), 1);
        let dayOfWeek = date.getDay();
        date.setDate(date.getDate() - dayOfWeek);
        return date;
      }

      width: parent.width
      height: 245
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
              color: isToday ? Dat.Colors.purple : Dat.Colors.foreground
              font.bold: isToday? true : false
              font.pointSize: 11
            }

            // Highlight Today's Date
            Rectangle {
              id: today
              color: Dat.Colors.foreground
              anchors.fill: parent
              radius: parent.radius
              opacity: isToday ? 0.5 : 0
            }
          }
        }
      }
    }

    // Check to see if day has changed
    Timer {
      interval: 60000
      running: true
      repeat: true
      onTriggered: {
        const now = new Date()
        if (!calendarGrid.isSameDay(now, calendarGrid.displayDate)) {
          loader.active = false
          loader.active = true
        }
      }
    }
  }
}
