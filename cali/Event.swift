//
//  Event.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

struct Event : Codable {
    let id: String
    var start: Date?
    var end: Date?
    var title: String?
    var formattedAddress: String?
    // var attendees : [Person] = []
    
    init() {
        id = NSUUID().uuidString
    }
}
