//
//  TrackerStore.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 15.02.2025.
//

import UIKit
import CoreData
protocol TrackerStoreDelegate: AnyObject {
    func didUpdate() -> Void
}
final class TrackerStore: NSObject {
    static let shared = TrackerStore()
    private override init() {
        super.init()
    }
    weak var delegate: TrackerStoreDelegate?
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching results: \(error)")
        }
        return fetchedResultsController
    }()
    private var context: NSManagedObjectContext {
        return DataBaseStore.shared.persistentContainer.viewContext
    }
    func convertToTracker(coreDataTracker: TrackerCoreData) -> Tracker {
        guard let id = coreDataTracker.id,
              let name = coreDataTracker.name,
              let color = coreDataTracker.color,
              let emoji = coreDataTracker.emoji,
              let schedule = coreDataTracker.schedule
        else {
            assertionFailure("Failed convert to Tracker")
            return Tracker(id: UUID(), name: "", color: UIColor(), emoji: "", schedule: [], isPinned: false)
        }
        let isPinned = coreDataTracker.isPinned
        let newColor = UIColorHex.color(from: color) ?? UIColor()
        let scheduleString = schedule.compactMap {
            WeekDay(rawValue: $0)
        }
        let tracker = Tracker(id: id, name: name, color: newColor, emoji: emoji, schedule: scheduleString, isPinned: isPinned)
        return tracker
    }
    func addTracker(tracker: Tracker, category: TrackerCategory) {
        let newTracker = TrackerCoreData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = UIColorHex.hexString(from: tracker.color)
        newTracker.schedule = tracker.schedule.compactMap {
            $0.rawValue
        }
        newTracker.isPinned = tracker.isPinned
        let fetchedCategory = TrackerCategoryStore.shared.fetchCategoryWithTitle(title: category.title)
        newTracker.category = fetchedCategory
        DataBaseStore.shared.saveContext()
    }
    func editTracker(name: String, tracker: Tracker, category: TrackerCategory) {
        let editedTracker = fetchTracker(name: name)
        editedTracker.id = tracker.id
        editedTracker.name = tracker.name
        editedTracker.emoji = tracker.emoji
        editedTracker.color = UIColorHex.hexString(from: tracker.color)
        editedTracker.schedule = tracker.schedule.compactMap {
            $0.rawValue
        }
        editedTracker.isPinned = tracker.isPinned
        let fetchedCategory = TrackerCategoryStore.shared.fetchCategoryWithTitle(title: category.title)
        editedTracker.category = fetchedCategory
        DataBaseStore.shared.saveContext()
    }
    func pinTracker(id: UUID) {
        let tracker = fetchTracker(with: id)
            tracker.isPinned = !tracker.isPinned
            DataBaseStore.shared.saveContext()
    }
    func deleteTracker(with name: String) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let objects = try context.fetch(request)
            context.delete(objects[0])
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        DataBaseStore.shared.saveContext()
    }
    func fetchTracker(with id: UUID) -> TrackerCoreData {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let uuid = id.uuidString
        request.predicate = NSPredicate(format: "id == %@", uuid)
        var object: [TrackerCoreData] = []
        do {
            object = try context.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return object[0]
    }
    func fetchTracker(name: String) -> TrackerCoreData {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "name == %@", name)
        var object: [TrackerCoreData] = []
        do {
            object = try context.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return object[0]
    }
    func log() {
        if let url = DataBaseStore.shared.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
    }
}
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
