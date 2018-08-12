//
//  MockWeatherService.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreLocation

class UITestWeatherService : WeatherService {
    func getWeather(location: CLLocation, block: @escaping (CurlError?, WeatherForcastResponse?) -> Void) {
        
    }
}
