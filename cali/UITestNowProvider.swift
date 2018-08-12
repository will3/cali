//
//  UITestNowProvider.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class UITestNowProvider : NowProvider {
    var now: Date
    
    init(now: Date) {
        self.now = now
    }
}
