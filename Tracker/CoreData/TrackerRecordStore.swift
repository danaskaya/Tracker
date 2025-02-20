//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 15.02.2025.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecord()
}

final class TrackerRecordStore: NSObject {
    static let shared = TrackerRecordStore()
    private override init() {
        super.init()
    }
    weak var delegate: TrackerRecordStoreDelegate?
    private var appDelegate: AppDelegate? {
        return (UIApplication.shared.delegate as? AppDelegate)
    }
    private var context: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    func addRecord(tracker: TrackerRecord) {
        guard let context = context else { return }
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.id = tracker.id
        newRecord.date = tracker.date
        appDelegate?.saveContext()
    }
    func deleteRecord(id: UUID) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let objects = try context?.fetch(request)
            if let deletedObject = objects?.first {
                context?.delete(deletedObject)
                appDelegate?.saveContext()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func fetchRecords() -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = TrackerRecordCoreData.fetchRequest()
        do {
            records = try context?.fetch(request) ?? []
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return records
    }
    func convertRecord(records: [TrackerRecordCoreData]) -> [TrackerRecord] {
        var returnedRecords: [TrackerRecord] = []
        for record in records {
            let newId = record.id
            if let newDate = record.date {
                let newRecord = TrackerRecord(id: newId, date: newDate)
                returnedRecords.append(newRecord)
            }
        }
        return returnedRecords
    }
}
