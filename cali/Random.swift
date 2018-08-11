//
//  Random.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Seeded random
class Random {
    var seed: Float
    
    init(seed: Float) {
        self.seed = seed
    }
    
    /// Returns a random float from range 0 - 1
    func next() -> Float {
        seed += 1
        let x = sin(seed) * 10000.0
        return x - floor(x)
    }
}
