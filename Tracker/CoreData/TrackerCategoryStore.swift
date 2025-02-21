//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 15.02.2025.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryUpdate(title: String)
}

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private override init() {
        super.init()
    }
    weak var delegate: TrackerCategoryStoreDelegate?
    private let colorHex = UIColorHex()
    private var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    private var context: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    func fetchCoreDataCategory() -> [TrackerCategoryCoreData] {
        var categories: [TrackerCategoryCoreData] = []
        guard let context = context else { return categories }
        let request = TrackerCategoryCoreData.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return categories
    }
    func fetchCategoryWithTitle(title: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "title == %@", title)
        do {
            let categories = try context?.fetch(request) ?? []
            return categories.first
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    func convertToCategory(_ categories: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        var returnedCategories: [TrackerCategory] = []
        for category in categories {
            guard let title = category.title else {
                continue
            }
            let allTrackers = category.trackers?.allObjects as? [TrackerCoreData] ?? []
            var trackers: [Tracker] = []
            for tracker in allTrackers {
                guard let trackerID = tracker.id,
                      let trackerName = tracker.name,
                      let trackerColor = tracker.color,
                      let trackerEmoji = tracker.emoji,
                      let trackerSchedule = tracker.schedule
                else {
                    continue
                }
                let newSchedule = trackerSchedule.compactMap {
                    WeekDay(rawValue: $0)
                }
                let newTracker = Tracker(
                    id: trackerID,
                    name: trackerName,
                    color: UIColorHex.color(from: trackerColor) ?? UIColor(),
                    emoji: trackerEmoji,
                    schedule: newSchedule)
                trackers.append(newTracker)
            }
            let category = TrackerCategory(title: title, trackers: trackers)
            returnedCategories.append(category)
        }
        return returnedCategories
    }
    func ifCategoryAlreadyExist(category: TrackerCategory) -> Bool {
        guard let categories = try? context?.fetch(TrackerCategoryCoreData.fetchRequest())
        else {
            return false
        }
        return categories.contains(where: { $0.title == category.title })
    }
    func addCategory(category: TrackerCategory) {
        guard let context = context else { return }
        if !ifCategoryAlreadyExist(category: category) {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = category.title
            appDelegate?.saveContext()
        }
    }
    func deleteCategory(with title: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", title)
        do {
            if let object = try context?.fetch(request), !object.isEmpty {
                context?.delete(object[0])
                delegate?.trackerCategoryUpdate(title: title)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        appDelegate?.saveContext()
    }
    public func log() {
        if let url = appDelegate?.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
    }
}
