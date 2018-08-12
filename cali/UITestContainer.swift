//
//  TestContainer.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

// Test container used in UITests 
class UITestContainer : Container {
    var calendar: Calendar = {
        var calendar = Calendar.current
        if let timeZone = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = timeZone
        }
        return calendar
    } ()

    var nowProvider: NowProvider = UITestNowProvider(now: Date(timeIntervalSince1970: 0))

    var weatherService: WeatherService = UITestWeatherService()

    var locationService: LocationService = UITestLocationService()

    var eventService: EventService = UITestEventService()

    var storage: Storage = UITestStorage()
}
