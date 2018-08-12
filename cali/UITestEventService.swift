//
//  MockEventService.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class UITestEventService : EventService {
    let context = Injection.defaultContainer.storage.context
    
    func find(startDay: Date) -> [Event] {
        return []
    }
    
    func createEvent(start: Date, duration: TimeInterval) -> Event {
        let event = Event(context: context)
        event.id = NSUUID().uuidString
        event.start = start
        event.duration = duration
        return event
    }
    
    func changeDay(event: Event, day: Date) {
        
    }
    
    func discardEvent(_ event: Event) {
        
    }
}
