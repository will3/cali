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
    
    let numWeeksBackwards = Int(ceil(8 * 365 / 7))
    let numWeeksForward = Int(ceil(2 * 365 / 7))
    
}
