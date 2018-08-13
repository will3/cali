// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Event.swift instead.

import Foundation
import CoreData

public enum EventAttributes: String {
    case durationNumber = "durationNumber"
    case id = "id"
    case planForWeatherNumber = "planForWeatherNumber"
    case start = "start"
    case title = "title"
}

open class _Event: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Event"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Event.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var durationNumber: NSNumber?

    @NSManaged open
    var id: String?

    @NSManaged open
    var planForWeatherNumber: NSNumber?

    @NSManaged open
    var start: Date?

    @NSManaged open
    var title: String?

    // MARK: - Relationships

}

