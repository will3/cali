//
//  MockStorage.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import CoreData

class UITestStorage : Storage {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "cali")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        // never saves
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func clear() {
        deleteAllData(type: Event.self, entity: Event.entityName())
    }
    
    func deleteAllData<T : NSFetchRequestResult>(type: T.Type, entity: String)
    {
        let req : NSFetchRequest<T>  = NSFetchRequest(entityName: entity)
        let deleteAllReq = NSBatchDeleteRequest(fetchRequest: req as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteAllReq)
        }
        catch {
            print(error)
            
        }
    }
}
