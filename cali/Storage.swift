//
//  Storage.swift
//  cali
//
//  Created by will3 on 8/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreData

protocol Storage {
    /// Save context
    func saveContext ()
    /// Context
    var context : NSManagedObjectContext { get }
    /// Remove everything, should only used in UI Tests
    func clear ()
}
