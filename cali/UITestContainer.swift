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
    lazy var calendar: Calendar = {
        var calendar = Calendar.current
        if let timeZone = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = timeZone
        }
        return calendar
    } ()

    lazy var nowProvider: NowProvider = {
        UITestNowProvider(now: Date(timeIntervalSince1970: 0))
    }()

    lazy var weatherService: WeatherService = {
        UITestWeatherService()
    }()

    lazy var locationService: LocationService = {
        UITestLocationService()
    }()

    lazy var eventService: EventService = {
        EventServiceImpl()
    }()

    lazy var storage: Storage = {
        UITestStorage()
    }()
}
