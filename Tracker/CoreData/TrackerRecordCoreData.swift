//
//  TrackerRecordCoreData.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 15.02.2025.
//

import Foundation
import CoreData
@objc(TrackerRecordCoreData)
public class TrackerRecordCoreData: NSManagedObject {
    
}
extension TrackerRecordCoreData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID
}
extension TrackerRecordCoreData : Identifiable {
    
}
