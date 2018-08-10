//
//  WeatherData.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class WeatherData : IDeserializable {
    required init() { }
    var time: Double? // 1533866406,
    var summary: String? // "Clear",
    var icon: String? // "clear-day",
    var nearestStormDistance: Double? // 0,
    var precipIntensity: Double? // 0,
    var precipProbability: Double? // 0,
    var temperature: Double? // 75.01,
    var apparentTemperature: Double? // 75.01,
    var dewPoint: Double? // 53.39,
    var humidity: Double? // 0.47,
    var pressure: Double? // 1011.9,
    var windSpeed: Double? // 6.74,
    var windGust: Double? // 10.78,
    var windBearing: Double? // 267,
    var cloudCover: Double? // 0.12,
    var uvIndex: Double? // 0,
    var visibility: Double? // 10,
    var ozone: Double? // 298.79
    
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
