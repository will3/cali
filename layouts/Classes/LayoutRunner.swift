//
//  LayoutRunner.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Main loop for layouts, mostly to release layouts
class LayoutRunner {
    /// Shared instance
    static let instance = LayoutRunner()
    /// Timer
    private var timer : Timer?;
    /// Started
    var started = false
    
    func startIfNeeded() {
        if started {
            return
        }
        start()
        started = true
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 60.0, repeats: true) { timer in
            self.checkViewReleased()
        }
        started = true
    }
    
    /// Release layout if view is released
    func checkViewReleased() {
        let keys = LayoutRegistry.layouts.keys
        for key in keys {
            if let layout = LayoutRegistry.layouts[key] {
                if (layout.view == nil) {
                    LayoutRegistry.layouts.removeValue(forKey: layout.id)
                }
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
        started = false
    }
}
