//
//  EventCell.swift
//  cali
//
//  Created by will3 on 8/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventCell : UITableViewCell {
    static let identifier = "EventCell"
    
    /// View did load
    private var didLoad = false
    /// Time label
    private let timeLabel = UILabel()
    /// Duration label
    private let durationLabel = UILabel()
    /// Title label
    private let titleLabel = UILabel()
    /// Left
    private let left = UIView()
    /// Right
    private let right = UIView()
    /// Weather hour view
    private let weatherHourView = WeatherHourView()
    /// Weather hour view layout
    private var weatherHourViewLayout: LayoutBuilder?
    
    /// Event
    var event: Event? {
        didSet {
            updateEvent()
        }
    }
    
    var weatherData: WeatherData? {
        didSet {
            updateWeather()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            if !didLoad {
                loadView()
                didLoad = true
            }
        }
    }
    
    private func loadView() {
        titleLabel.numberOfLines = 3
        let weatherHourViewLayout = layout(weatherHourView).width(0.0)
        self.weatherHourViewLayout = weatherHourViewLayout
        
        layout(contentView)
            .translatesAutoresizingMaskIntoConstraints()
            .stackHorizontal([
            layout(left)
                .width(80.0)
                .hugMore()
                .resistMore()
                .stack([
                    layout(timeLabel).left(18).top(14),
                    layout(durationLabel).left(18).top(2).bottom(18)
                    ]),
            layout(right)
                .justifyItems(.leading)
                .stack([
                     layout(titleLabel).left(18).top(12).right(18)
                    ]),
            weatherHourViewLayout
            ]).install()
        
        timeLabel.font = Fonts.fontSmall
        durationLabel.font = Fonts.fontSmall
        titleLabel.font = Fonts.fontMedium
        
        timeLabel.textColor = Colors.black
        durationLabel.textColor = Colors.primary
        titleLabel.textColor = Colors.black
    
        self.accessibilityLabel = AccessibilityIdentifier.eventCell
        self.isAccessibilityElement = true
    }
    
    private func updateEvent() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        timeLabel.text = DateFormatters.hmmaFormatter.string(from: start)
        durationLabel.text = EventFormatter.formatDuration(from: start, to: end, style: .short)
        titleLabel.text = event.displayTitle
    }
    
    private func updateWeather() {
        if weatherData == nil {
            weatherHourViewLayout?
                .width(0.0).reinstall()
            weatherHourView.isHidden = true
        } else {
            weatherHourViewLayout?
                .width(weatherHourView.preferredWidth).reinstall()
            weatherHourView.isHidden = false
            
            weatherHourView.weatherData = weatherData
        }
    }
}
