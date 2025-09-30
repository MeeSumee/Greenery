pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // Yoinked from sora's shell + added some of my own
  readonly property var weatherIcons: ({
    "113": "clear_day",
    "114": "bedtime",
    "115": "partly_cloudy_night",
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

  property string loc
  property list<string> tempC: ["??", "??", "??", "??", "??", "??", "??", "??", "??"]
  property list<string> icon: ["cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert"]
  property list<string> tempF: ["??", "??", "??", "??", "??", "??", "??", "??", "??"]
  property list<string> time: ["??", "??", "??", "??", "??", "??", "??", "??", "??"]
  property string description: "Unknown"
  property string feelstempC: "??"
  property string feelstempF: "??"
  property string area: "Unknown"
  property string sunrise: "??"
  property string sunset: "??"
  
  // Accepted strings: csv coordinates, airport code, city name, landmark
  // Reference: https://github.com/chubin/wttr.in
  property string weatherLocation: ""
  property bool useFahrenheit: false // Enable fahrenheit

  // fetch weather location or use IP location
  function reload(): void {
    if (weatherLocation)
      loc = weatherLocation;
    else if (!loc || timer.elapsed() > 10000) {
      var xhr = new XMLHttpRequest();
      xhr.open("GET", "https://ipinfo.io/json");
      xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
          if (xhr.status === 200) {
            try {
              var response = JSON.parse(xhr.responseText);
              loc = response.city ?? "";
              timer.restart();
            } catch (e) {
              console.error("Failed to parse IP info JSON:", e);
            }
          } else {
            console.error("HTTP request for IP info failed with status:", xhr.status);
          }
        }
      }
      xhr.send();
    }
  }

  // Fetch weather icon
  function getWeatherIcon(code: string): string {
    if (weatherIcons.hasOwnProperty(code))
      return weatherIcons[code];
    return "cloud_alert";
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
            const weatherToday = json.weather;
            const location = json.nearest_area?.[0];

            if (!current) {
              console.error("No current_condition found.");
              return;
            }

            if (!weatherToday) {
              console.error("No weather found for today");
              return;
            }

            // Set all necessary values for derivation or presentation
            icon[0] = current ? getWeatherIcon(current.weatherCode): "cloud_alert";
            tempC[0] = `${parseFloat(current.temp_C)}` ?? "??";
            tempF[0] = `${parseFloat(current.temp_F)}` ?? "??";
            time[0] = "Updated:" + `${current.localObsDateTime}`.slice(-9) ?? "??";
            description = current.weatherDesc?.[0]?.value ?? "Unknown";
            area = location.areaName?.[0]?.value ?? "Unknown";
            feelstempC = "Feels like: " + `${parseFloat(current.FeelsLikeC)}` + "°C" ?? "??";
            feelstempF = "Feels like: " + `${parseFloat(current.FeelsLikeF)}` + "°F" ?? "??";
            sunrise = weatherToday?.[0]?.astronomy?.[0]?.sunrise ?? "??";
            sunset = weatherToday?.[0]?.astronomy?.[0]?.sunset ?? "??";

            // For loop to get array index values and set value for another array
            for (var i=0; i < 8; i++) {
              tempC[i+1] = `${parseFloat(weatherToday?.[0]?.hourly?.[i]?.tempC)}` ?? "??";
              tempF[i+1] = `${parseFloat(weatherToday?.[0]?.hourly?.[i]?.tempF)}` ?? "??";
              time[i+1] = `${weatherToday?.[0]?.hourly?.[i]?.time}`.slice(0,-2) + ":" + `${weatherToday?.[0]?.hourly?.[i]?.time}`.slice(-2) ?? "??";
            }
            
            // Force set midnight 0 and change to 0:00
            time[1] = "0:00";
            
            // Most fucked up check for sunrise & sunset and change icons from sun to moon
            for (var i=0; i < 8; i++) {
              if(((13 + parseFloat(sunset.slice(0,2)) < parseFloat(time[i+1].slice(0,-3))) || (parseFloat(sunrise.slice(0,2)) > parseFloat(time[i+1].slice(0,-3)))) && weatherToday?.[0]?.hourly?.[i]?.weatherCode === "113") {
                const sunrcode = (parseFloat(weatherToday?.[0]?.hourly?.[i]?.weatherCode) + 1).toString();
                icon[i+1] = weatherToday ? getWeatherIcon(sunrcode) : "cloud_alert";
              }
              else if(((13 + parseFloat(sunset.slice(0,2)) < parseFloat(time[i+1].slice(0,-2))) || (parseFloat(sunrise.slice(0,2)) > parseFloat(time[i+1].slice(0,-2)))) && weatherToday?.[0]?.hourly?.[i]?.weatherCode === "116") {
                const sunscode = (parseFloat(weatherToday?.[0]?.hourly?.[i]?.weatherCode) - 1).toString();
                icon[i+1] = weatherToday ? getWeatherIcon(sunscode) : "cloud_alert";
              }
              else {
                icon[i+1] = weatherToday ? getWeatherIcon(weatherToday?.[0]?.hourly?.[i]?.weatherCode) : "cloud_alert";
              }
            }

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

  ElapsedTimer {
    id: timer
  }

  Component.onCompleted: {
    reload()
    refresh.start()
  }

  // 1hr refresh
  Timer {
    id: refresh
    interval: 3600000
    repeat: true
    running: false
    onTriggered: fetchWeather()
  }
}
