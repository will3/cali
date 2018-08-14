//
//  WeatherFormatter.swift
//  cali
//
//  Created by will3 on 13/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Weather formatter
class WeatherFormatter {
    private static let measurementFormatter = MeasurementFormatter()
    
    /// Format precipitation
    static func formatPrecipProbability(_ precipProbability: Double) -> String {
        return "\(Int(floor(precipProbability * 100.0)))%"
    }
    
    /**
     * Format fahrenheit
     * - parameter fahrenheit: Temperature in fahrenheit
     * - returns: Formatted string
     */
    static func formatFahrenheit(_ fahrenheit: Double) -> String {
        var measurement = fahrenheitToCelsius(fahrenheit)
        measurement.value = round(measurement.value)
        return measurementFormatter.string(from: measurement)
    }
    
    /**
     * Format temperature range
     * - parameter fahrenheitA: Temperature a
     * - parameter fahrenheitA: Temperature b
     * - returns: Formatted string
     */
    static func formatTempRange(fahrenheitA: Double, fahrenheitB: Double) -> String {
        let a = Int(round(fahrenheitToCelsius(fahrenheitA).value))
        let b = Int(round(fahrenheitToCelsius(fahrenheitB).value))
        return "\(a) - \(b)"
    }
    
    /**
     * Convert fahrenheit to celsius
     * - parameter fahrenheit: Temperature in fahrenheit
     * - returns: Temperature in celsius
     */
    private static func fahrenheitToCelsius(_ fahrenheit: Double) -> Measurement<UnitTemperature> {
        var measurement = Measurement(value: fahrenheit, unit: UnitTemperature.fahrenheit)
        measurement.convert(to: UnitTemperature.celsius)
        return measurement
    }
}
