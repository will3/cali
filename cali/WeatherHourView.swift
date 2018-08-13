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

class WeatherHourView : UIView {
    private var loaded = false
    let iconView = WeatherIconView()
    let tempLabel = UILabel()
    let percentageLabel = UILabel()
    let container = UIView()
    let preferredWidth = Float(50)
    var weatherData : WeatherData? { didSet { updateWeather() } }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    private func loadView() {
        layout(container)
            .parent(self)
            .horizontal(.stretch)
            .vertical(.center)
            .alignItems(.center)
            .stack([
                layout(percentageLabel),
                layout(iconView).width(18).height(18),
                layout(tempLabel)
                ])
            .priority(999)
            .install()
        
        percentageLabel.font = Fonts.fontSmall
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = Colors.accent
        
        tempLabel.font = Fonts.fontSmall
        tempLabel.textAlignment = .center
    }
    
    private func updateWeather() {
        if weatherData == nil {
            self.isHidden = true
        } else {
            self.isHidden = false
            
            if let precipProbability = weatherData?.precipProbability {
                percentageLabel.text = WeatherFormatter.formatPrecipProbability(precipProbability)
            } else {
                percentageLabel.text = " "
            }
            
            iconView.icon = weatherData?.icon
            
            if let temperature = weatherData?.temperature {
                tempLabel.text = WeatherFormatter.formatFahrenheit(temperature)
            } else {
                tempLabel.text = " "
            }
        }
    }
}
