//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 22.02.2025.
//

import Foundation

class CategoryViewModel {
    private(set) var categories: [String] = [] {
        didSet {
            changed?()
        }
    }
    var selectedCategory: String = ""
    var changed: (() -> Void)?
    func getCategories() {
        let getCategories = TrackerCategoryStore.shared.fetchCategories()
        for getCategory in getCategories {
            categories.append(getCategory.title)
        }
    }
    func numberOfRows() -> Int {
        categories.count
    }
    func deleteCategory(with title: String) {
        TrackerCategoryStore.shared.deleteCategory(with: title)
        categories.removeAll { category in
            category == title
        }
    }
    func updateCategory(category: String) {
        categories.append(category)
    }
}
