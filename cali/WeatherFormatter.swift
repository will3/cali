//
//  WeatherFormatter.swift
//  cali
//
//  Created by will3 on 13/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class WeatherFormatter {
    static let measurementFormatter = MeasurementFormatter()
    static func formatPrecipProbability(_ precipProbability: Double) -> String {
        return "\(Int(floor(precipProbability * 100.0)))%"
    }
    
    static func formatFahrenheit(_ fahrenheit: Double) -> String {
        var measurement = Measurement(value: fahrenheit, unit: UnitTemperature.fahrenheit)
        measurement.convert(to: UnitTemperature.celsius)
        measurement.value = round(measurement.value)
        return measurementFormatter.string(from: measurement)
    }
}
