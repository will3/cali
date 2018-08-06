//
//  Event.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

struct Event : Storable {
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
    
    var startDay: Date? {
        if let start = self.start {
            return Calendar.current.startOfDay(for: start)
        } else {
            return nil
        }
    }
    
    mutating func changeDay(_ day: Date) {
        guard let start = self.start else { return }
        var fromComponents =
            Calendar.current.dateComponents(
                [.year,.month,.day,.hour,.minute,.second],
                from: start)
        let toComponents =
            Calendar.current.dateComponents(
                [.year,.month,.day],
                from: day)
        fromComponents.year = toComponents.year
        fromComponents.month = toComponents.month
        fromComponents.day = toComponents.day
        self.start = Calendar.current.date(from: fromComponents)
    }
    
    init() {
        id = NSUUID().uuidString
    }
    
    func getID() -> String {
        return id
    }
}
