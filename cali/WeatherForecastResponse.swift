//
//  WeatherForecastResponse.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Weather forcast response object, full documentation on https://darksky.net/dev
class weatherForecastResponse : Deserializable {
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
        
        initMap()
    }
    
    /// Map of weather data, by UTC Date
    private var map: [ Date: WeatherData ] = [:]
    
    /// Init map
    private func initMap() {
        guard let offset = self.offset else { return }
        guard let daily = self.daily else { return }
        
        map.removeAll()
        
        for data in daily.data ?? [] {
            guard let time = data.time else { continue }
            // Note date is UTC, and CalendarDates dates are localized by calendar timezone
            let date = Date(timeIntervalSince1970: time + offset * TimeIntervals.hour)
            map[date] = data
        }
    }
    
    /// Get forecast by UTC date 
    func getForecast(dateUTC: Date) -> WeatherData? {
        return map[dateUTC]
    }
}
