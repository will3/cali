//
//  WeatherService.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/// Weather service
protocol WeatherService {
    /**
     * Get weather
     * 
     * - parameter location: location
     * - returns: Promise of WeatherForecastResponse or CurlError
     */
    func getWeather(location: CLLocation) -> Promise<WeatherForecastResponse, ServiceError>
}
