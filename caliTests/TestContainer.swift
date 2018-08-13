//
//  TestContainer.swift
//  caliTests
//
//  Created by will3 on 14/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
@testable import cali

class TestContainer : Container {
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
    
    lazy var weatherService : WeatherService = {
        return MockWeatherService()
    }()
    
    lazy var locationService : LocationService = {
        return MockLocationService()
    }()
    
    lazy var eventService : EventService = {
        return MockEventService()
    }()
    
    lazy var storage : Storage = {
        return MockStorage()
    }()
}
