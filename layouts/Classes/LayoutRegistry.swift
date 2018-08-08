//
//  LayoutRegistry.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class LayoutRegistry {
    static var layouts: [UUID : Layout] = [:]
    static func add(layout: Layout) {
        layouts[layout.id] = layout
    }
}
