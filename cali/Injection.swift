//
//  Container.swift
//  cali
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Injection
class Injection {
    /// The default container
    static var defaultContainer : Container!
}

/// Container
protocol Container {
    var calendar : Calendar { get }
    
    var nowProvider : NowProvider { get }
    
    var weatherService : WeatherService { get }
    
    var locationService : LocationService { get }
    
    var eventService : EventService { get }
    
    var storage : Storage { get }
}

class DefaultContainer : Container {
    /// Calendar
    lazy var calendar = {
        Calendar.current
    }()
    
    // Now provider
    lazy var nowProvider : NowProvider = {
        NowProviderImpl()
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
