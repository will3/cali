//
//  MainViewControllerSpec.swift
//  caliTests
//
//  Created by will3 on 14/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import XCTest
@testable import cali
import Quick
import Nimble
import Cuckoo
import CoreLocation

class MainViewControllerSpec: QuickSpec {
    
    override func spec() {
        var weatherService : MockWeatherService!
        var mainViewController: MainViewController!
        
        beforeEach() {
            Injection.defaultContainer = TestContainer()
            weatherService = Injection.defaultContainer.weatherService as! MockWeatherService
            mainViewController = MainViewController()
        }
        
        it("should update weather") {
            stub(weatherService) { stub in
                when(stub.getWeather(location: any()))
                    .thenReturn(Promise<WeatherForecastResponse, ServiceError>(value: WeatherForecastResponse()))
            }
            
            mainViewController.location = CLLocation()
            
            expect(mainViewController.weatherForecast).toNot(beNil())
        }
    }
}
