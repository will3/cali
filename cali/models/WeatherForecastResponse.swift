//
//  WeatherForecastResponse.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class WeatherForcastResponse : IDeserializable {
    required init() { }
    
    var latitude: Double? // 37.8267,
    var longitude: Double? // -122.4233,
    var timezone: String? // "America/Los_Angeles",
    var currently: WeatherData? // {},
    var minutely: WeatherDataMultiple? // {},
    var hourly: WeatherDataMultiple? // {},
    var daily: WeatherDataMultiple? // {},
    //    var flags // {},
    var offset: Double? // -7
    
    func deserialize(json: [String : Any]) {
        latitude = json["latitude"] as? Double
        longitude = json["longitude"] as? Double
        timezone = json["timezone"] as? String
        currently = Deserializer.deserialize(json: json["currently"])
        minutely = Deserializer.deserialize(json: json["minutely"])
        hourly = Deserializer.deserialize(json: json["hourly"])
        daily = Deserializer.deserialize(json: json["daily"])
        offset = json["offset"] as? Double
    }
}
