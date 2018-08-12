//
//  LocationService.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate {
    func locationServiceDidUpdateLocation(_ locationService: LocationService)
}

struct LocationServiceNotifications {
    /// Update notification name
    static let didUpdate = NSNotification.Name("locationServiceDidUpdateNotificationName")
}

/**
 * Location Service
 * call ensure location to get user location
 * emits LocationServiceNotifications.didUpdate when location is updated
 */
protocol LocationService {
    var location: CLLocation? { get }
    
    /**
     * Ensure location
     * If location permission has not been requested, request permission and fetch location once
     * If location permission has been authorized, fetch location once
     * If location permission has been denied, show change settings alert
     *
     * - parameter from: View controller used to display alerts
     */
    func ensureLocation(from: UIViewController)
}
