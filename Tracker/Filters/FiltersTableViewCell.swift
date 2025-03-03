//
//  FiltersTableViewCell.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 25.02.2025.
//
import UIKit

class FiltersTableViewCell: UITableViewCell {
    let filters: [String] = [
        NSLocalizedString("All trackers", comment: ""),
        NSLocalizedString("Trackers for today", comment: ""),
        NSLocalizedString("CompletedTrackers", comment: ""),
        NSLocalizedString("Not completed trackers", comment: "")
    ]
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    func set(with indexPath: IndexPath) {
        textLabel?.text = filters[indexPath.row]
        backgroundColor = Colors.shared.dark
    }
}
