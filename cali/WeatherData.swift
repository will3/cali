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

    // Sunrise time
    var sunriseTime: Double?
    // Sunset time
    var sunsetTime: Double?
    // Moon phase
    var moonPhase: Double?
    // Precip intensity max
    var precipIntensityMax: Double?
    // Temperature high
    var temperatureHigh: Double?
    // Temperature high time
    var temperatureHighTime: Double?
    // Temperature low
    var temperatureLow: Double?
    // Temperature low time
    var temperatureLowTime: Double?
    // Apparent temperature high
    var apparentTemperatureHigh: Double?
    // Apparent temperature high time
    var apparentTemperatureHighTime: Double?
    // Apparent temperature low
    var apparentTemperatureLow: Double?
    // Apparent temperature low time
    var apparentTemperatureLowTime: Double?
    // Wind gust time
    var windGustTime: Double?
    // Uv index time
    var uvIndexTime: Double?
    // Temperature min
    var temperatureMin: Double?
    // Temperature min time
    var temperatureMinTime: Double?
    // Temperature max
    var temperatureMax: Double?
    // Temperature max time
    var temperatureMaxTime: Double?
    // Apparent temperature min
    var apparentTemperatureMin: Double?
    // Apparent temperature min time
    var apparentTemperatureMinTime: Double?
    // Apparent temperature max
    var apparentTemperatureMax: Double?
    // Apparent temperature max time
    var apparentTemperatureMaxTime: Double?
    
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

        sunriseTime = json["sunriseTime"] as? Double
        sunsetTime = json["sunsetTime"] as? Double
        moonPhase = json["moonPhase"] as? Double
        precipIntensityMax = json["precipIntensityMax"] as? Double
        temperatureHigh = json["temperatureHigh"] as? Double
        temperatureHighTime = json["temperatureHighTime"] as? Double
        temperatureLow = json["temperatureLow"] as? Double
        temperatureLowTime = json["temperatureLowTime"] as? Double
        apparentTemperatureHigh = json["apparentTemperatureHigh"] as? Double
        apparentTemperatureHighTime = json["apparentTemperatureHighTime"] as? Double
        apparentTemperatureLow = json["apparentTemperatureLow"] as? Double
        apparentTemperatureLowTime = json["apparentTemperatureLowTime"] as? Double
        windGustTime = json["windGustTime"] as? Double
        uvIndexTime = json["uvIndexTime"] as? Double
        temperatureMin = json["temperatureMin"] as? Double
        temperatureMinTime = json["temperatureMinTime"] as? Double
        temperatureMax = json["temperatureMax"] as? Double
        temperatureMaxTime = json["temperatureMaxTime"] as? Double
        apparentTemperatureMin = json["apparentTemperatureMin"] as? Double
        apparentTemperatureMinTime = json["apparentTemperatureMinTime"] as? Double
        apparentTemperatureMax = json["apparentTemperatureMax"] as? Double
        apparentTemperatureMaxTime = json["apparentTemperatureMaxTime"] as? Double
    }
}
