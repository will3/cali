//
//  EventsService.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreData

class EventMap {
    var map : [Date : Set<Event>] = [:]

    func removeAll() {
        map.removeAll()
    }
    
    func addEvent(_ event: Event) {
        guard let startDay = event.startDay else { return }
        if map[startDay] == nil {
            map[startDay] = []
        }
        
        map[startDay]?.insert(event)
    }
    
    func removeEvent(_ event: Event) {
        guard let startDay = event.startDay else { return }
        map[startDay]?.remove(event)
    }
    
    func find(startDay: Date) -> [Event] {
        let result = map[startDay] ?? []
        return result.sorted(by: { (a, b) -> Bool in
            if a.start == nil { return true }
            if b.start == nil { return false }
            return a.start! > b.start!
        })
    }
}

class EventService {
    static let instance = EventService()
    let context = Storage.instance.context
    let map = EventMap()
    var hasInitEventMap = false
    
    func find(startDay: Date) -> [Event] {
        initEventMapIfNeeded()
        return map.find(startDay: startDay)
    }
    
    func createEvent(start: Date, duration: TimeInterval) -> Event {
        let event = Event(context: context)
        event.id = NSUUID().uuidString
        event.start = start
        event.duration = duration
        map.addEvent(event)
        
        try? context.save()
        
        return event
    }
    
    func changeDay(event: Event, day: Date) {
        guard let start = event.start else { return }
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
        let nextStart = Calendar.current.date(from: fromComponents)
        map.removeEvent(event)
        event.start = nextStart
        map.addEvent(event)
        
        try? context.save()
    }
    
    func discardEvent(_ event: Event) {
        // Destroy event
        context.delete(event)
        map.removeEvent(event)
        
        try? context.save()
    }
    
    private func initEventMapIfNeeded() {
        if !hasInitEventMap {
            initEventMap()
            hasInitEventMap = true
        }
    }
    
    private func initEventMap() {
        map.removeAll()
        let events = findAll()
        
        for event in events {
            map.addEvent(event)
        }
    }
    
    private func findAll() -> [Event] {
        let request = NSFetchRequest<Event>(entityName: Event.entityName())
        let results = try? context.fetch(request)
        return results ?? []
    }
    
    
}
