pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // Accepted strings: csv coordinates, airport code, city name, landmark
  // Reference: https://github.com/chubin/wttr.in
  property string weatherLocation: ""
  property bool imperial: false // Enable imperial units (fahrenheit, mph, etc)

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

  // Wind Direction Mapper
  readonly property var winddir16Point: ({
    "N": "south",
    "E": "west",
    "S": "north",
    "W": "east",
    "NE": "south_west",
    "NNE": "south_west",
    "ENE": "south_west",
    "NW": "south_east",
    "NNW": "south_east",
    "WNW": "south_east",
    "SE": "north_west",
    "SSE": "north_west",
    "ESE": "north_west",
    "SW": "north_east",
    "SSW": "north_east",
    "WSW": "north_east"
  })

  property string loc
  property list<string> temp: ["??", "??", "??", "??", "??", "??", "??", "??", "??"]
  property list<string> icon: ["cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert", "cloud_alert"]
  property list<string> time: ["??", "??", "??", "??", "??", "??", "??", "??", "??"]
  property string description: "Unknown"
  property string feelstemp: "??"
  property string area: "Unknown"
  property string sunrise: "??"
  property string sunset: "??"
  property string uvindex: "??"
  property string wind: "??"
  property string winddir: "emergency_heat_2"

  signal weatherReady()

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

  // I added this cause fuck AM/PM time
  function conv24hr(timeString) {
    const [time, period] = timeString.split(' ');
    const [hour, minute] = time.split(':');
    let formattedHour = parseInt(hour);

    if (period === 'PM' && hour != 12) {
      formattedHour += 12;
    }

    return `${formattedHour}:${minute}`;
  }

  // I added this for the american monkes
  function conv12hr(timeString) {
    const [hour, minute] = timeString.split(':');
    let formattedHour = parseInt(hour);

    if (hour > 12) {
      formattedHour -= 12;
      return `${formattedHour}:${minute} PM`
    }
    
    else if (hour === 12) {
      return `${formattedHour}:${minute} PM`
    }

    else if (hour === 0) {
      formattedHour += 12;
      return `${formattedHour}:${minute} AM`
    }

    else {
      return `${formattedHour}:${minute} AM`
    }
  }

  // Fetch weather icon
  function getWeatherIcon(code: string): string {
    if (weatherIcons.hasOwnProperty(code))
      return weatherIcons[code];
    return "cloud_alert";
  }

  function getWindIcon(point) {
    if (winddir16Point.hasOwnProperty(point))
      return winddir16Point[point];
    return "emergency_heat_2";
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
            temp[0] = imperial ? parseFloat(current.temp_F) : parseFloat(current.temp_C);
            time[0] = imperial ? current.localObsDateTime.slice(-7) : conv24hr(current.localObsDateTime.slice(-8));
            description = current.weatherDesc?.[0]?.value ?? "Unknown";
            area = location.areaName?.[0]?.value ?? "Unknown";
            feelstemp = imperial ? parseFloat(current.FeelsLikeF) : parseFloat(current.FeelsLikeC);
            sunrise = imperial ? weatherToday?.[0]?.astronomy?.[0]?.sunrise.slice(-7) : conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunrise);
            sunset = imperial ? weatherToday?.[0]?.astronomy?.[0]?.sunset.slice(-7) : conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunset);
            wind = imperial ? current.windspeedMiles : current.windspeedKmph;
            winddir = getWindIcon(current.winddir16Point) ?? "emergency_heat_2";
            uvindex = current.uvIndex ?? "??";

            // IF CHECKS CAUSE I'M RETARDED LOL
            if((parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunset).slice(0,2)) < parseInt(conv24hr((current.localObsDateTime).slice(-8))) || parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunrise).slice(0,2)) > parseInt(conv24hr((current.localObsDateTime).slice(-8)))) && current.weatherCode === "113") {
              const rcode = (parseFloat(current.weatherCode) + 1).toString();
              icon[0] = current ? getWeatherIcon(rcode) : "cloud_alert";
            }
            else if((parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunset).slice(0,2)) < parseInt(conv24hr((current.localObsDateTime).slice(-8))) || parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunrise).slice(0,2)) > parseInt(conv24hr((current.localObsDateTime).slice(-8)))) && current.weatherCode === "116") {
              const scode = (parseFloat(current.weatherCode) - 1).toString();
              icon[0] = current ? getWeatherIcon(scode) : "cloud_alert";
            }
            else {
              icon[0] = current ? getWeatherIcon(current.weatherCode) : "cloud_alert";
            }

            // For loop to get array index values and set value for another array
            for (var i=0; i < 8; i++) {
              temp[i+1] = imperial ? parseFloat(weatherToday?.[0]?.hourly?.[i]?.tempF) : parseFloat(weatherToday?.[0]?.hourly?.[i]?.tempC) ?? "??";
              if (weatherToday?.[0]?.hourly?.[i]?.time === "0") {
                time[i+1] = imperial ? conv12hr("0:00") : "0:00";
              }
              else {
                time[i+1] = imperial ? conv12hr(`${weatherToday?.[0]?.hourly?.[i]?.time.slice(0,-2)}:${weatherToday?.[0]?.hourly?.[i]?.time.slice(-2)}`) : `${weatherToday?.[0]?.hourly?.[i]?.time.slice(0,-2)}:${weatherToday?.[0]?.hourly?.[i]?.time.slice(-2)}`;
              }
            }
            
            // Force set midnight 0 and change to 0:00
            time[1] = imperial ? conv12hr("0:00") : "0:00";
            
            // Most fucked up check for sunrise & sunset and change icons from sun to moon
            for (var i=0; i < 8; i++) {
              if((parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunset).slice(0,2)) < parseInt(`${weatherToday?.[0]?.hourly?.[i]?.time}`.slice(0,-2)) || parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunrise).slice(0,2)) > parseInt(`${weatherToday?.[0]?.hourly?.[i]?.time}`.slice(0,-2))) && weatherToday?.[0]?.hourly?.[i]?.weatherCode === "113") {
                const sunrcode = (parseFloat(weatherToday?.[0]?.hourly?.[i]?.weatherCode) + 1).toString();
                icon[i+1] = weatherToday ? getWeatherIcon(sunrcode) : "cloud_alert";
              }
              else if((parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunset).slice(0,2)) < parseInt(`${weatherToday?.[0]?.hourly?.[i]?.time}`.slice(0,-2)) || parseInt(conv24hr(weatherToday?.[0]?.astronomy?.[0]?.sunset).slice(0,2)) > parseInt(`${weatherToday?.[0]?.hourly?.[i]?.time}`.slice(0,-2))) && weatherToday?.[0]?.hourly?.[i]?.weatherCode === "116") {
                const sunscode = (parseFloat(weatherToday?.[0]?.hourly?.[i]?.weatherCode) - 1).toString();
                icon[i+1] = weatherToday ? getWeatherIcon(sunscode) : "cloud_alert";
              }
              else {
                icon[i+1] = weatherToday ? getWeatherIcon(weatherToday?.[0]?.hourly?.[i]?.weatherCode) : "cloud_alert";
              }
            }

            // Signal Weather Ready status to Temperature Graph
            root.weatherReady()

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
