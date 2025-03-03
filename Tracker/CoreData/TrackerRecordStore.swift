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
    private var context: NSManagedObjectContext? {
        return DataBaseStore.shared.persistentContainer.viewContext
    }
    func addRecord(tracker: TrackerRecord) {
        guard let context = context else { return }
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.id = tracker.id
        newRecord.date = tracker.date
        DataBaseStore.shared.saveContext()
    }
    func deleteRecord(id: UUID, date: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let uuid = id.uuidString
        let idPredicate = NSPredicate(format: "id == %@", uuid)
        let datePredicate = NSPredicate(format: "date == %@", date as CVarArg)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, datePredicate])
        request.predicate = compoundPredicate
        do {
            let objects = try context?.fetch(request)
            if let deletedObject = objects?.first {
                context?.delete(deletedObject)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        DataBaseStore.shared.saveContext()
    }
    func deleteRecord(with id: UUID) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let uuid = id.uuidString
        request.predicate = NSPredicate(format: "id == %@", uuid)
        do {
            if let objects = try context?.fetch(request) {
                for object in objects {
                    context?.delete(object)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        DataBaseStore.shared.saveContext()
    }
    func fetchRecord(with id: UUID) -> [TrackerRecordCoreData] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let uuid = id.uuidString
        request.predicate = NSPredicate(format: "id == %@", uuid)
        do {
            if let fetcedRecords = try context?.fetch(request) {
                return fetcedRecords
            } else {
                return []
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
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
    func getCountOfCompletedTrackers() -> Int {
        fetchRecords().count
    }
}
