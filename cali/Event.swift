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
    var duration: TimeInterval?
    var end: Date? {
        guard let start = self.start else { return nil }
        guard let duration = self.duration else { return nil }
        return start.addingTimeInterval(duration)
    }
    
    var title: String?
    var attendees : [Person] = []
    
    init() {
        id = NSUUID().uuidString
    }
}
