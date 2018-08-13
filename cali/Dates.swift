//
//  Dates.swift
//  cali
//
//  Created by will3 on 13/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class Dates {
    static func localToUTC(date: Date) -> Date {
        return date.addingTimeInterval(Double(TimeZone.current.secondsFromGMT()))
    }
}
