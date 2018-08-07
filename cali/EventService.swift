//
//  EventsService.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class EventService {
    static let instance = EventService()
    let eventsCollection = Collection<Event>(name: "events")
    
    func insert(event: Event) {
        eventsCollection.insert(object: event)
    }
    
    func update(event: Event) {
        eventsCollection.update(object: event)
    }
    
    func find() -> [Event] {
        return eventsCollection.find()
    }
    
    func find(startDay: Date) -> [Event] {
        return eventsCollection.find().filter({ (event) -> Bool in
            return event.startDay == startDay
        })
    }
    
    func find(filter: (Event) -> Bool) -> [Event] {
        return eventsCollection.find().filter(filter)
    }
}
