//
//  WeatherView.swift
//  cali
//
//  Created by will3 on 13/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class WeatherView : UIView {
    private var loaded = false
    
    var weatherForecast : weatherForecastResponse? { didSet { updateWeatherForecast() } }
    
    /// If today, set the time, otherwise, set start of day
    var date : Date? { didSet { updateWeatherForecast() } }
    
    var isNow: Bool {
        guard let date = self.date else { return false }
        let calendar = Injection.defaultContainer.calendar
        let now = Injection.defaultContainer.nowProvider.now
        return calendar.startOfDay(for: now) == calendar.startOfDay(for: date)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    let iconView = WeatherIconView()
    let timeLabel = UILabel()
    let summaryLabel = UILabel()
    let tempLabel = UILabel()
    let formatter = MeasurementFormatter()
    
    private func loadView() {
        let view = UIView()
        
        layout(view)
            .matchParent(self)
            .stack([
                layout(timeLabel),
                layout(summaryLabel),
                layout(iconView).width(24).height(24),
                layout(tempLabel),
                ]).install()
    }
    
    private func updateWeatherForecast() {
        guard let date = self.date else { return }
        
        if isNow {
            
            guard let currently = weatherForecast?.currently else { return }
            
            timeLabel.text = DateFormatters.EEEEhhmmaFormatter.string(from: date)
            summaryLabel.text = currently.summary
            iconView.icon = currently.icon
            
            if let temperature = currently.temperature {
                let measurement = Measurement(value: temperature, unit: UnitTemperature.fahrenheit)
                tempLabel.text = formatter.string(from: measurement)
            }
            
        } else {
            timeLabel.text = DateFormatters.EEEEFormatter.string(from: date)
        }
    }
}
