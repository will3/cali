//
//  Storage.swift
//  cali
//
//  Created by will3 on 8/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreData

/// Storage provides an interface to Core data storage
protocol Storage {
    
    /// Save context
    func saveContext ()
    
    /// Context, used in main thread
    var context : NSManagedObjectContext { get }
    
    /// Remove everything, should only used in UI Tests
    func clear ()
}
