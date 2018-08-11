import Foundation

@objc(Event)
open class Event: _Event {
	// Custom logic goes here.
    
    /// Start day
    var startDay: Date? {
        if let start = self.start {
            let calendar = Container.instance.calendar
            return calendar.startOfDay(for: start)
        } else {
            return nil
        }
    }
    
    /// Duration
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
    
    /// End
    var end: Date? {
        guard let start = self.start else { return nil }
        guard let duration = self.duration else { return nil }
        return start.addingTimeInterval(duration)
    }
    
    /// Display title
    var displayTitle: String {
        if let title = self.title {
            if !title.isEmpty {
                return title
            }
        }
        
        return NSLocalizedString("Untitled", comment: "")
    }
}
