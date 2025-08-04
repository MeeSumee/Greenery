pragma Singleton

import Quickshell
import QtQuick
import qs.Data as Dat

Singleton {
    id: root

    property string loc
    property string icon
    property string description
    property string tempC: "0°C"
    property string tempF: "0°F"
    property string weatherLocation: "39.9526, -75.1652" // Enter Latitude and Longitude
    property bool useFahrenheit: false // Enable fahrenheit

    function reload(): void {
        if (weatherLocation)
            loc = weatherLocation;
        else if (!loc || timer.elapsed() > 900)
            Requests.get("https://ipinfo.io/json", text => {
                loc = JSON.parse(text).loc ?? "";
                timer.restart();
            });
    }

    onLocChanged: Requests.get(`https://wttr.in/${loc}?format=j1`, text => {
        const json = JSON.parse(text).current_condition[0];
        icon = Icons.getWeatherIcon(json.weatherCode);
        description = json.weatherDesc[0].value;
        tempC = `${parseFloat(json.temp_C)}°C`;
        tempF = `${parseFloat(json.temp_F)}°F`;
    })

    Component.onCompleted: reload()

    ElapsedTimer {
        id: timer
    }
}