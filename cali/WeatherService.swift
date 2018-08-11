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
     * - parameter block: return block
     */
    func getWeather(location: CLLocation, block: @escaping(CurlError?, WeatherForcastResponse?) -> Void)
}

class WeatherServiceImpl : WeatherService {
    func getWeather(location: CLLocation, block: @escaping(CurlError?, WeatherForcastResponse?) -> Void) {
        let url = URL(string: "https://api.darksky.net/forecast/\(Settings.instance.darkSkyApiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)")!
        
        Curl.get(url: url) { (err, json) in
            if err != nil {
                block(err, nil)
            } else {
                let response : WeatherForcastResponse? = Deserializer.deserialize(json: json)
                block(nil, response)
            }
        }
    }
}
