//
//  Container.swift
//  cali
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Injection container
class Container {
    static var instance = Container()
    
    /// Calendar
    var calendar = Calendar.current
    
    // Now provider
    let nowProvider = NowProvider()
}
