//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 10.02.2025.
//

import UIKit
protocol ScheduleCellDelegate: AnyObject {
    func switchChanged(forDay day: WeekDay, selected: Bool)
}
class ScheduleCell: UITableViewCell {
    var switchStates: [Bool] = []
    weak var delegate: ScheduleCellDelegate?
    private var weekDays: WeekDay?
    let cellDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellDaysLabel)
        NSLayoutConstraint.activate([
            cellDaysLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    func setSwitch(for switchView: UISwitch, at indexPath: IndexPath) {
        switchView.setOn(false, animated: true)
        switchView.onTintColor = .blue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        self.accessoryView = switchView
    }
    @objc func switchChanged(_ sender: UISwitch) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let day = WeekDay.allCases[indexPath.row]
        delegate?.switchChanged(forDay: day, selected: sender.isOn)
    }
}
