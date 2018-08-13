//
//  EventMap.swift
//  cali
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Event map
class EventMap {
    private var map : [Date : Set<Event>] = [:]
    
    /// Remove all
    func removeAll() {
        map.removeAll()
    }
    
    /// Add event
    func addEvent(_ event: Event) {
        guard let startDay = event.startDay else { return }
        if map[startDay] == nil {
            map[startDay] = []
        }
        
        map[startDay]?.insert(event)
    }
    
    /// Remove event
    func removeEvent(_ event: Event) {
        guard let startDay = event.startDay else { return }
        map[startDay]?.remove(event)
    }
    
    /// Find events in day
    func find(startDay: Date) -> [Event] {
        let result = map[startDay] ?? []
        return result.sorted(by: { (a, b) -> Bool in
            if a.start == nil { return true }
            if b.start == nil { return false }
            return a.start! < b.start!
        })
    }
}
