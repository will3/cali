//
//  EventsService.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreData

protocol EventService {
    func find(startDay: Date) -> [Event]
    func createEvent(start: Date, duration: TimeInterval) -> Event
    func changeDay(event: Event, day: Date)
    func discardEvent(_ event: Event)
}

class EventServiceImpl : EventService {
    private let context = Container.instance.storage.context
    private let map = EventMap()
    private var hasInitEventMap = false
    private let calendar = Container.instance.calendar
    
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
            calendar.dateComponents(
                [.year,.month,.day,.hour,.minute,.second],
                from: start)
        let toComponents =
            calendar.dateComponents(
                [.year,.month,.day],
                from: day)
        fromComponents.year = toComponents.year
        fromComponents.month = toComponents.month
        fromComponents.day = toComponents.day
        let nextStart = calendar.date(from: fromComponents)
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
