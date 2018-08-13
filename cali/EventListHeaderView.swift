//
//  EventListHeaderView.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventListHeaderView: UITableViewHeaderFooterView {
    static let identifier = "EventListHeaderView"
    
    private let weatherIconView = WeatherIconView()
    private let weatherContainer = UIView()
    private let weatherLabel = UILabel()
    
    var weather: WeatherData? { didSet { updateWeather() } }
    
    private static var dayWeekMonthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEddMMMM")
        return dateFormatter
    }()
    
    private static var dayWeekMonthYearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEddMMMMyyyy")
        return dateFormatter
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var didLoad = false
    
    var date: Date? { didSet { updateLabel() } }
    let calendar = Injection.defaultContainer.calendar
    let label = UILabel()
    
    override func didMoveToSuperview() {
        if (!didLoad) {
            loadView();
            didLoad = true
        }
    }
    
    func loadView() {
        contentView.addSubview(label)
        
        layout(label)
            .left(18)
            .right(18)
            .horizontal(.stretch)
            .vertical(.center)
            .install()
        
        weatherLabel.font = Fonts.fontSmall
        weatherLabel.textColor = Colors.primary
        
        layout(weatherContainer)
            .parent(self)
            .vertical(.center)
            .pinRight(6)
            .stackHorizontal([
            layout(weatherIconView)
                .width(12)
                .height(12)
                .right(6),
            layout(weatherLabel).right(6)
            ]).install()
        
        updateLabel()
    }
    
    func updateLabel() {
        guard let date = self.date else { return }
        
        let now = Injection.defaultContainer.nowProvider.now
        
        let dateFormatter = calendar.isDate(date, equalTo: now, toGranularity: .year) ?
            EventListHeaderView.dayWeekMonthFormatter :
            EventListHeaderView.dayWeekMonthYearFormatter
        
        let dateText = dateFormatter.string(from: date)
        
        let isToday = calendar.isDateInToday(date)
        var firstText: String?
        if calendar.isDateInYesterday(date) {
            firstText = NSLocalizedString("Yesterday", comment: "")
        } else if isToday {
            firstText = NSLocalizedString("Today", comment: "")
        } else if calendar.isDateInTomorrow(date) {
            firstText = NSLocalizedString("Tomorrow", comment: "")
        }
        
        let string = NSMutableAttributedString()
        
        if let text = firstText {
            string.append(
                NSAttributedString(
                    string: "\(text) • ",
                    attributes: [
                        NSAttributedStringKey.font : Fonts.headerFontMedium
                    ]))
        }
        
        string.append(
            NSAttributedString(
                string: dateText,
                attributes: [
                    NSAttributedStringKey.font : Fonts.headerFont
                ]))
        
        label.attributedText = string

        if isToday {
            contentView.backgroundColor = Colors.lightAccent
            label.textColor = Colors.accent
        } else {
            contentView.backgroundColor = Colors.dimBackground
            label.textColor = Colors.primary
        }
    }
    
    private func updateWeather() {
        if let weather = self.weather {
            weatherIconView.icon = weather.icon
            if let temperatureLow = weather.temperatureLow, let temperatureHigh = weather.temperatureHigh {
                weatherLabel.text = WeatherFormatter.formatTempRange(fahrenheitA: temperatureLow, fahrenheitB: temperatureHigh)
            } else {
                weatherLabel.text = ""
            }
            weatherIconView.isHidden = false
        } else {
            weatherLabel.text = ""
            weatherIconView.isHidden = true
        }
    }
}
