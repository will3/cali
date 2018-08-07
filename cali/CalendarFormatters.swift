//
//  CalendarFormatters.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class DateFormatters {
    static let LLLFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL";
        return formatter
    }()
    
    static let LLLLFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL";
        return formatter
    }()
    
    static let EEEddMMMFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEddMMM")
        return formatter
    }()
    
    static let hmmaFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    static let hmmFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
    
    static let EECommaDMMMFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, d MMM"
        return formatter
    }()
    
    static let haFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter
    }();
}
