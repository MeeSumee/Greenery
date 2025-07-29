// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "dddd MMMM d hh:mm")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
