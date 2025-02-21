//
//  TrackerStoreExtensions.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 15.02.2025.
//

import Foundation
import CoreData
@objc(TrackerCoreData)
public class TrackerCoreData: NSManagedObject {
    
}
extension TrackerCoreData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }
    @NSManaged public var color: String?
    @NSManaged public var completedDays: Int16
    @NSManaged public var emoji: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var schedule: [String]?
    @NSManaged public var category: TrackerCategoryCoreData?
}
extension TrackerCoreData : Identifiable {
    
}
