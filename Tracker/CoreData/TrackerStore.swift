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
    private var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let context = context else {
            fatalError("Failed to get context")
        }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching results: \(error)")
        }
        return fetchedResultsController
    }()
    private var context: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    func convertToTracker(coreDataTracker: TrackerCoreData) -> Tracker {
        guard let id = coreDataTracker.id,
              let name = coreDataTracker.name,
              let color = coreDataTracker.color,
              let emoji = coreDataTracker.emoji,
              let schedule = coreDataTracker.schedule
        else {
            assertionFailure("Failed convert to Tracker")
            return Tracker(id: UUID(), name: "", color: UIColor(), emoji: "", schedule: [])
        }
        let newColor = UIColorHex.color(from: color) ?? UIColor()
        let scheduleString = schedule.compactMap {
            WeekDay(rawValue: $0)
        }
        let tracker = Tracker(id: id, name: name, color: newColor, emoji: emoji, schedule: scheduleString)
        return tracker
    }
    func addTracker(tracker: Tracker, category: TrackerCategory) {
        guard let context = context else { return }
        let newTracker = TrackerCoreData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = UIColorHex.hexString(from: tracker.color)
        newTracker.schedule = tracker.schedule.compactMap {
            $0.rawValue
        }
        let fetchedCategory = TrackerCategoryStore.shared.fetchCategoryWithTitle(title: category.title)
        newTracker.category = fetchedCategory
        appDelegate?.saveContext()
    }
    func deleteTracker(with name: String) {
        guard let context = context else { return }
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let objects = try context.fetch(request)
            if let objectToDelete = objects.first {
                context.delete(objectToDelete)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        appDelegate?.saveContext()
    }
    func fetchTrackers() {
        do {
            try fetchedResultsController.performFetch()
            fetchedResultsController.fetchedObjects?.forEach { tracker in
                let object = convertToTracker(coreDataTracker: tracker)
            }
        } catch {
            print("Error fetching results: \(error)")
        }
    }
    public func log() {
        if let url = appDelegate?.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
    }
}
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
