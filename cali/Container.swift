//
//  Container.swift
//  cali
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Injection container
class Container {
    static var instance = Container()
    
    /// Calendar
    lazy var calendar = {
        Calendar.current
    }()
    
    // Now provider
    lazy var nowProvider = {
        NowProvider()
    }()
    
    // Weather service
    lazy var weatherService : WeatherService = {
        WeatherServiceImpl()
    }()
    
    // Location service
    lazy var locationService : LocationService = {
        LocationServiceImpl()
    }()
    
    // Event service
    lazy var eventService : EventService = {
        EventServiceImpl()
    }()
    
    // Storage
    lazy var storage : Storage = {
        StorageImpl()
    }()
}
