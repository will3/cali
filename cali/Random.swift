//
//  Random.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class Random {
    var seed: Float
    
    init(seed: Float) {
        self.seed = seed
    }
    
    func next() -> Float {
        seed += 1
        let x = sin(seed) * 10000.0
        return x - floor(x)
    }
}
