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
    private var offset: Double?
    
    func deserialize(json: [String : Any]) {
        latitude = json["latitude"] as? Double
        longitude = json["longitude"] as? Double
        timezone = json["timezone"] as? String
        currently = Deserializer.deserialize(json: json["currently"])
        minutely = Deserializer.deserialize(json: json["minutely"])
        hourly = Deserializer.deserialize(json: json["hourly"])
        daily = Deserializer.deserialize(json: json["daily"])
        offset = json["offset"] as? Double
        
        initDayMap()
        initHourMap()
    }
    
    /// Map of weather data, by UTC Date
    private var dayMap: [ Date: WeatherData ] = [:]
    /// Map of weather data, by UTC Date
    private var hourMap: [ Date: WeatherData ] = [:]
    
    /// Init day map
    private func initDayMap() {
        guard let offset = self.offset else { return }
        guard let daily = self.daily else { return }
        
        dayMap.removeAll()
        
        for data in daily.data ?? [] {
            guard let time = data.time else { continue }
            // Note date is UTC, and CalendarDates dates are localized by calendar timezone
            let date = Date(timeIntervalSince1970: time + offset * TimeIntervals.hour)
            dayMap[date] = data
        }
    }
    
    /// Init hour map
    private func initHourMap() {
        guard let offset = self.offset else { return }
        guard let hourly = self.hourly else { return }
        
        hourMap.removeAll()
        
        for data in hourly.data ?? [] {
            guard let time = data.time else { continue }
            let date = Date(timeIntervalSince1970: time + offset * TimeIntervals.hour)
            hourMap[date] = data
        }
    }
    
    /// Get weather by UTC date 
    func getWeather(dateUTC: Date) -> WeatherData? {
        return dayMap[dateUTC]
    }
    
    /// Get weather for event
    func getWeather(event: Event) -> WeatherData? {
        guard let start = event.start else { return nil }
        let startUTC = Dates.localToUTC(date: start)
        let calendar = Injection.defaultContainer.calendar
        let components = calendar.dateComponents([.year,.month,.day,.hour], from: startUTC)
        guard let hour = calendar.date(from: components) else { return nil }
        
        return hourMap[hour]
    }
}
