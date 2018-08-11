//
//  WeatherIconView.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

/// Weather icon view
class WeatherIconView : UIView {
    /// Icon to show
    var icon : String? { didSet { updateIcon() } }
    /// Has background
    var hasBackground = false { didSet {
        if hasBackground {
            backgroundColor = Colors.white
        } else {
            backgroundColor = UIColor.clear
        } } }

    private let imageView = UIImageView()
    private var loaded = false
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            if !loaded {
                loadView()
                loaded = true
            }
        }
    }
    
    private func loadView() {
        self.alpha = 0.9
        layout(imageView).center(self).width(22).height(22).install()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2
        clipsToBounds = true
    }
    
    private func updateIcon() {
        if let icon = getIcon() {
            imageView.image = icon
            isHidden = false
        } else {
            isHidden = true
        }
    }
    
    private func getIcon() -> UIImage? {
        if icon == "clear-day" {
            return UIImage(named:"weather_clear-day")
        } else if icon == "clear-night" {
            return UIImage(named:"weather_clear-night")
        } else if icon == "cloudy" {
            return UIImage(named:"weather_cloudy")
        } else if icon == "fog" {
            return UIImage(named:"weather_fog")
        } else if icon == "partly-cloudy-day" {
            return UIImage(named:"weather_partly-cloudy-day")
        } else if icon == "partly-cloudy-night" {
            return UIImage(named:"weather_partly-cloudy-night")
        } else if icon == "rain" {
            return UIImage(named:"weather_rain")
        } else if icon == "sleet" {
            return UIImage(named:"weather_sleet")
        } else if icon == "snow" {
            return UIImage(named:"weather_snow")
        } else if icon == "wind" {
            return UIImage(named:"weather_wind")
        }
        return nil
    }
}
