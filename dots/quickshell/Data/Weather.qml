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

    function fetchWeather() {
        console.log("Fetching weather for location:", loc);

        var xhr = new XMLHttpRequest();
        xhr.open("GET", `https://wttr.in/${loc}?format=j1`);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    console.log("Raw response:", xhr.responseText);
                    try {
                        const json = JSON.parse(xhr.responseText);
                        const current = json.current_condition?.[0];

                        if (!current) {
                            console.error("No current_condition found.");
                            return;
                        }

                        //icon = Icons.getWeatherIcon(current.weatherCode);
                        description = current.weatherDesc?.[0]?.value ?? "Unknown";
                        tempC = `${parseFloat(current.temp_C)}°C`;
                        tempF = `${parseFloat(current.temp_F)}°F`;

                        console.log("Updated temps:", tempC, tempF);
                    } catch (e) {
                        console.error("Failed to parse weather JSON:", e);
                    }
                } else {
                    console.error("HTTP request failed with status:", xhr.status);
                }
            }
        };
        xhr.send();
    }

    onLocChanged: fetchWeather()

    Component.onCompleted: reload()

    ElapsedTimer {
        id: timer
    }
}
