//
//  WeatherForecastResponse.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Weather forcast response object, full documentation on https://darksky.net/dev
class WeatherForcastResponse : Deserializable {
    required init() { }
    
    /// Latitude
    var latitude: Double?
    /// Longitude
    var longitude: Double?
    /// Timezone
    var timezone: String?
    /// Forecast currently
    var currently: WeatherData?
    /// Forecast minutely
    var minutely: WeatherDataMultiple?
    /// Forecast hourly
    var hourly: WeatherDataMultiple?
    /// Forecast daily
    var daily: WeatherDataMultiple?
    /// Offset
    var offset: Double?
    
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
