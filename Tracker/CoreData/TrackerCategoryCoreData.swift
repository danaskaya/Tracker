//
//  TrackerCategoryCoreData.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 15.02.2025.
//

import Foundation
import CoreData
@objc(TrackerCategoryCoreData)
public class TrackerCategoryCoreData: NSManagedObject {
    
}
extension TrackerCategoryCoreData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCategoryCoreData> {
        return NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    }
    @NSManaged public var title: String?
    @NSManaged public var trackers: NSSet?
}
extension TrackerCategoryCoreData {
    @objc(addTrackersObject:)
    @NSManaged public func addToTrackers(_ value: TrackerCoreData)
    @objc(removeTrackersObject:)
    @NSManaged public func removeFromTrackers(_ value: TrackerCoreData)
    @objc(addTrackers:)
    @NSManaged public func addToTrackers(_ values: NSSet)
    @objc(removeTrackers:)
    @NSManaged public func removeFromTrackers(_ values: NSSet)
}
extension TrackerCategoryCoreData : Identifiable {
    
}
