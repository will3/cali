//
//  WeatherPopup.swift
//  cali
//
//  Created by will3 on 13/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class WeatherPopup : UIView {
    private var loaded = false
    let weatherView = WeatherView()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    private func loadView() {
        self.backgroundColor = Colors.fadeBackgroundColor
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WeatherPopup.didTapBackground)))
        layout(weatherView).width(120).center(self).install()
    }
    
    @objc func didTapBackground() {
        removeFromSuperview()
    }
}
