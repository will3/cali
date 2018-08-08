import Foundation

@objc(Event)
open class Event: _Event {
	// Custom logic goes here.
    
    var startDay: Date? {
        if let start = self.start {
            return Calendar.current.startOfDay(for: start)
        } else {
            return nil
        }
    }
    
    var duration: TimeInterval? {
        get {
            return durationNumber?.doubleValue
        }
        set(optional) {
            if let value = optional {
                durationNumber = NSNumber(value: value)
            }
        }
    }
    
    var end: Date? {
        guard let start = self.start else { return nil }
        guard let duration = self.duration else { return nil }
        return start.addingTimeInterval(duration)
    }
}
