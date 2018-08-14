//
//  TimeIntervalsSpec.swift
//  caliTests
//
//  Created by will3 on 14/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
@testable import cali
import Quick
import Nimble

class WeatherFormatterSpec: QuickSpec {
    override func spec() {
        it("Formats precip probability") {
            let text = WeatherFormatter.formatPrecipProbability(0.01)
            expect(text).to(equal("1%"))
        }
        
        it("Formats fahrenheit") {
            let text = WeatherFormatter.formatFahrenheit(32)
            expect(text).to(equal("32°F"))
        }
        
        it("Formats temperature range") {
            let text = WeatherFormatter.formatTempRange(fahrenheitA: 64.0, fahrenheitB: 80.0)
            expect(text).to(equal("18 - 27"))
        }
    }
}

class 
