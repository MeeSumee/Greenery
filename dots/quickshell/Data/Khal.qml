// Credit: https://github.com/bbedward/DankMaterialShell
// Khal calendar fetcher
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool khalAvailable: false
    property var eventsByDate: ({
    })
    property bool isLoading: false
    property string lastError: ""
    property date lastStartDate
    property date lastEndDate

    function checkKhalAvailability() {
        if (!khalCheckProcess.running)
            khalCheckProcess.running = true;

    }

    function loadCurrentMonth() {
        if (!root.khalAvailable)
            return ;

        let today = new Date();
        let firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
        let lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        // Add padding
        let startDate = new Date(firstDay);
        startDate.setDate(startDate.getDate() - firstDay.getDay() - 7);
        let endDate = new Date(lastDay);
        endDate.setDate(endDate.getDate() + (6 - lastDay.getDay()) + 7);
        loadEvents(startDate, endDate);
    }

    function loadEvents(startDate, endDate) {
        if (!root.khalAvailable) {
            return ;
        }
        if (eventsProcess.running) {
            return ;
        }
        // Store last requested date range for refresh timer
        root.lastStartDate = startDate;
        root.lastEndDate = endDate;
        root.isLoading = true;
        // Format dates for khal (MM/dd/yyyy based on printformats)
        let startDateStr = Qt.formatDate(startDate, "MM/dd/yyyy");
        let endDateStr = Qt.formatDate(endDate, "MM/dd/yyyy");
        eventsProcess.requestStartDate = startDate;
        eventsProcess.requestEndDate = endDate;
        eventsProcess.command = ["khal", "list", "--json", "title", "--json", "description", "--json", "start-date", "--json", "start-time", "--json", "end-date", "--json", "end-time", "--json", "all-day", "--json", "location", "--json", "url", startDateStr, endDateStr];
        eventsProcess.running = true;
    }

    function getEventsForDate(date) {
        let dateKey = Qt.formatDate(date, "yyyy-MM-dd");
        return root.eventsByDate[dateKey] || [];
    }

    function hasEventsForDate(date) {
        let events = getEventsForDate(date);
        return events.length > 0;
    }

    // Initialize on component completion
    Component.onCompleted: {
        checkKhalAvailability();
    }

    // Process for checking khal configuration
    Process {
        id: khalCheckProcess

        command: ["khal", "list", "today"]
        running: false
        onExited: (exitCode) => {
            root.khalAvailable = (exitCode === 0);
            if (exitCode === 0) {
                loadCurrentMonth();
            }
        }
    }
}
