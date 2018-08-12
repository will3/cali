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
