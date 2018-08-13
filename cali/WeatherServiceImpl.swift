//
//  WeatherServiceImpl.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherServiceImpl : WeatherService {
    func getWeather(location: CLLocation, block: @escaping(CurlError?, weatherForecastResponse?) -> Void) {
        let url = URL(string: "https://api.darksky.net/forecast/\(Settings.instance.darkSkyApiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)")!
        
        Curl.get(url: url) { (err, json) in
            if err != nil {
                block(err, nil)
            } else {
                let response : weatherForecastResponse? = Deserializer.deserialize(json: json)
                block(nil, response)
            }
        }
    }
}
