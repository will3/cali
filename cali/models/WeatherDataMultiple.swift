//
//  WeatherDataMultiple.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Weather data multiple
class WeatherDataMultiple : Deserializable {
    /// Summary
    var summary: String?
    /// Icon
    var icon: String?
    /// Data
    var data: [WeatherData]?
    
    required init() { }
    
    func deserialize(json: [String: Any]) {
        summary = json["summary"] as? String
        icon = json["icon"] as? String
        let jsonArray = json["data"] as? [[String: Any]]
        data = Deserializer.deserializeArray(jsonArray: jsonArray)
    }
}
