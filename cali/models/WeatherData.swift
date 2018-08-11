//
//  WeatherData.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Weather data
class WeatherData : Deserializable {
    required init() { }

    /// Time
    var time: Double?

    /// Summary
    var summary: String?

    /// Icon
    var icon: String?

    /// Nearest storm distance
    var nearestStormDistance: Double?

    /// Precip intensity
    var precipIntensity: Double?

    /// Precip probability
    var precipProbability: Double?

    /// Temperature
    var temperature: Double?

    /// Apparent temperature
    var apparentTemperature: Double?

    /// Dew point
    var dewPoint: Double?

    /// Humidity
    var humidity: Double?

    /// Pressure
    var pressure: Double?

    /// Wind speed
    var windSpeed: Double?

    /// Wind gust
    var windGust: Double?

    /// Wind bearing
    var windBearing: Double?

    /// Cloud cover
    var cloudCover: Double?

    /// Uv index
    var uvIndex: Double?

    /// Visibility
    var visibility: Double?

    /// Ozone
    var ozone: Double?
    
    func deserialize(json: [String: Any]) {
        time = json["time"] as? Double
        summary = json["summary"] as? String
        icon = json["icon"] as? String
        nearestStormDistance = json["nearestStormDistance"] as? Double
        precipIntensity = json["precipIntensity"] as? Double
        precipProbability = json["precipProbability"] as? Double
        temperature = json["temperature"] as? Double
        apparentTemperature = json["apparentTemperature"] as? Double
        dewPoint = json["dewPoint"] as? Double
        humidity = json["humidity"] as? Double
        pressure = json["pressure"] as? Double
        windSpeed = json["windSpeed"] as? Double
        windGust = json["windGust"] as? Double
        windBearing = json["windBearing"] as? Double
        cloudCover = json["cloudCover"] as? Double
        uvIndex = json["uvIndex"] as? Double
        visibility = json["visibility"] as? Double
        ozone = json["ozone"] as? Double
    }
}
