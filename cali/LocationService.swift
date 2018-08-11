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

/// Location service
class LocationService : NSObject, CLLocationManagerDelegate {
    /// Location manager
    private let locationManager = CLLocationManager()

    /// Location
    private(set) var location: CLLocation?
    
    /// Update notification name
    static let didUpdateNotificationName = NSNotification.Name("locationServiceDidUpdateNotificationName")
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    /** 
     * Ensure location
     * If location permission has not been requested, request permission and fetch location once
     * If location permission has been authorized, fetch location once
     * If location permission has been denied, show change settings alert
     * 
     * - parameter from: View controller used to display alerts
     */
    func ensureLocation(from: UIViewController) {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            showLocationPermission(from: from)
            break
        case .restricted, .denied:
            showEnabledLocation(from: from)
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            break
        }
    }
    
    // MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations[locations.count - 1]
        NotificationCenter.default.post(name: LocationService.didUpdateNotificationName, object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        default:
            break
        }
    }

    // MARK: Private
    
    /// Show location permission prompt
    private func showLocationPermission(from: UIViewController) {
        let alertController = UIAlertController(title: NSLocalizedString("Enable location for weather forecasts", comment: ""), message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:
            { (action) in
                self.locationManager.requestWhenInUseAuthorization()
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:nil))
        
        from.present(alertController, animated: true, completion: nil)
    }
    
    /// Show Enable location prompt
    private func showEnabledLocation(from: UIViewController) {
        let alertController = UIAlertController(title: NSLocalizedString("Enable location for weather forecasts", comment: ""), message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:
            { (action) in
                self.gotoLocationSettings()
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:nil))
        
        from.present(alertController, animated: true, completion: nil)
    }
    
    /// Show go to location settings prompt
    private func gotoLocationSettings() {
        if !CLLocationManager.locationServicesEnabled() {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
