//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 10.02.2025.
//

import UIKit
protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectScheduleDays(_ days: [WeekDay])
}
final class ScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedDays: [WeekDay] = []
    private lazy var scheduleTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("scheduleTitle", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        button.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped(_ :)), for: .touchUpInside)
        button.backgroundColor = Colors.shared.buttonsBackground
        button.layer.cornerRadius = 16
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scheduleTitle)
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scheduleTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            scheduleTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scheduleTableView.topAnchor.constraint(equalTo: scheduleTitle.bottomAnchor, constant: 40),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    func getWeekDay(day: String) -> String {
        let formatString: String = NSLocalizedString(day, comment: "")
        return formatString
    }
    @objc func doneButtonTapped(_ sender: UIAction) {
        delegate?.didSelectScheduleDays(selectedDays)
        dismiss(animated: true)
    }
}
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let switchView = UISwitch()
        let weekDay = WeekDay.allCases[indexPath.row].rawValue
        cell.cellDaysLabel.text = getWeekDay(day: weekDay)
        cell.setSwitch(for: switchView, at: indexPath)
        cell.delegate = self
        cell.backgroundColor = Colors.shared.dark
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastcell = indexPath.row == 6
        if lastcell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height
        return height / 7
    }
}
extension ScheduleViewController: UITableViewDelegate {
    
}
extension ScheduleViewController: ScheduleCellDelegate {
    func switchChanged(forDay day: WeekDay, selected: Bool) {
        if selected {
            selectedDays.append(day)
        } else {
            selectedDays.removeAll(where: {$0 == day})
        }
    }
}

