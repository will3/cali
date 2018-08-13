//
//  CalendarFormatters.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Date foramtter cache
class DateFormatters {
    /// Formatter with format: LLL
    static let LLLFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL";
        return formatter
    }()
    
    /// Formatter with format: LLLL
    static let LLLLFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL";
        return formatter
    }()
    
    /// Formatter with format: LLLL yyyy
    static let LLLLyyyyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy";
        return formatter
    }()
    
    /// Formatter with date formate template: EEEddMMM
    static let EEEddMMMFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEddMMM")
        return formatter
    }()
    
    /// Formatter with format: h:mm a
    static let hmmaFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    /// Formatter with format: h:mm
    static let hmmFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
    
    /// Formatter with format: EE, d MMM
    static let EECommaDMMMFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, d MMM"
        return formatter
    }()
    
    /// Formatter with format: h a
    static let haFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter
    }();
    
    /// Formatter with format: MMMM
    static let MMMMFormmater : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    /// Formatter with format: EEEEhhmma
    static let EEEEhhmmaFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEhhmma")
        return formatter
    }()
    
    /// Formatter with format: EEEE
    static let EEEEFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter
    }()
}
