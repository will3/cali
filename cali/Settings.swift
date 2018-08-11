//
//  Settings.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class Settings {
    static let instance = Settings()
    
    /// Number of weeks to show backwards, in calendar
    let numWeeksBackwards = Int(ceil(8 * 365 / 7))

    /// Number of weeks to show forward, in calendar
    let numWeeksForward = Int(ceil(2 * 365 / 7))
    
    let darkSkyApiKey = "62ededef08cf69bc5d6ddd7dd52f36b7"
}
