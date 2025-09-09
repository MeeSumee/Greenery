pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property string loc
    property list<string> icon
    readonly property var weatherIcons: ({
            "113": "clear_day",
            "116": "partly_cloudy_day",
            "119": "cloud",
            "122": "cloud",
            "143": "foggy",
            "176": "rainy",
            "179": "rainy",
            "182": "rainy",
            "185": "rainy",
            "200": "thunderstorm",
            "227": "cloudy_snowing",
            "230": "snowing_heavy",
            "248": "foggy",
            "260": "foggy",
            "263": "rainy",
            "266": "rainy",
            "281": "rainy",
            "284": "rainy",
            "293": "rainy",
            "296": "rainy",
            "299": "rainy",
            "302": "weather_hail",
            "305": "rainy",
            "308": "weather_hail",
            "311": "rainy",
            "314": "rainy",
            "317": "rainy",
            "320": "cloudy_snowing",
            "323": "cloudy_snowing",
            "326": "cloudy_snowing",
            "329": "snowing_heavy",
            "332": "snowing_heavy",
            "335": "snowing",
            "338": "snowing_heavy",
            "350": "rainy",
            "353": "rainy",
            "356": "rainy",
            "359": "weather_hail",
            "362": "rainy",
            "365": "rainy",
            "368": "cloudy_snowing",
            "371": "snowing",
            "374": "rainy",
            "377": "rainy",
            "386": "thunderstorm",
            "389": "thunderstorm",
            "392": "thunderstorm",
            "395": "snowing"
        })
    property string description: "Unknown"
    property list<string> tempC
    property list<string> tempF
    property string feelstempC
    property string feelstempF
    property string humidity
    property list<string> time
    // Accepted strings: csv coordinates, airport code, city name, landmark
    // Reference: https://github.com/chubin/wttr.in
    property string weatherLocation: "philadelphia"
    property bool useFahrenheit: false // Enable fahrenheit

    // fetch weather location either based on predefined Latitude and Longitude
    // or use IP location
    function reload(): void {
        if (weatherLocation)
            loc = weatherLocation;
        else if (!loc || timer.elapsed() > 900)
            Requests.get("https://ipinfo.io/json", text => {
                loc = JSON.parse(text).loc ?? "";
                timer.restart();
            });
    }

    // Fetch weather icon
    function getWeatherIcon(code: string): string {
        if (weatherIcons.hasOwnProperty(code))
            return weatherIcons[code];
        return "air";
    }

    // eel magick
    function fetchWeather() {
        console.log("Fetching weather for location:", loc);

        var xhr = new XMLHttpRequest();
        xhr.open("GET", `https://wttr.in/${loc}?format=j1`);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // console.log("Raw response:", xhr.responseText);
                    try {
                        const json = JSON.parse(xhr.responseText);
                        const current = json.current_condition?.[0];
                        // const weatherToday = json.weather?.[0];

                        if (!current) {
                            console.error("No current_condition found.");
                            return;
                        }

                        // if (!weatherToday) {
                        //   console.error("No weather found for today");
                        //   return;
                        // }

                        icon[0] = current ? getWeatherIcon(current.weatherCode): "cloud_alert";
                        description = current.weatherDesc?.[0]?.value ?? "Unknown";
                        tempC[0] = `${parseFloat(current.temp_C)}°C`;
                        tempF[0] = `${parseFloat(current.temp_F)}°F`;
                        feelstempC = `${parseFloat(current.FeelsLikeC)}°C`;
                        feelstempF = `${parseFloat(current.FeelsLikeF)}°F`;
                        humidity = `${parseFloat(current.humidity)}%`;

                        // for (var i=0; i < 9; i++) {
                        //   icon[i+1] = weatherToday ? getWeatherIcon(weatherToday.hourly[i].weatherCode) : "cloud_alert";
                        //   tempC[i+1] = `${parseFloat(weatherToday.hourly[i].temp_C)}°C`;
                        //   tempF[i+1] = `${parseFloat(weatherToday.hourly[i].temp_F)}°F`;
                        // }
                        
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
