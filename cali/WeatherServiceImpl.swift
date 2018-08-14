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
    func getWeather(location: CLLocation) -> Promise<WeatherForecastResponse, ServiceError> {
        let url = URL(string: "https://api.darksky.net/forecast/\(Settings.instance.darkSkyApiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)")!
        
        let promise = Promise<WeatherForecastResponse, ServiceError>()
        
        Curl.get(url: url) { (err, json) in
            if let err = err {
                promise.reject(err: .curlError(err))
            } else {
                if let response : WeatherForecastResponse = Deserializer.deserialize(json: json) {
                    promise.resolve(value: response)
                } else {
                    promise.reject(err: .badData)
                }
            }
        }
        
        return promise
    }
}
