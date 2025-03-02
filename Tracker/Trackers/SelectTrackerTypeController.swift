//
//  TrackerCreateViewController.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 10.02.2025.
//

import UIKit
final class SelectTrackerTypeController: UIViewController {
    weak var habitCreateViewControllerDelegate: TrackerCreateViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("selectHabitTitle", comment: "")
        title.font = .systemFont(ofSize: 16, weight: .medium)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("selectHabitTitle", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Colors.shared.buttonsBackground
        button.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
        return button
    }()
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("selectIrregularEventTitle", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Colors.shared.buttonsBackground
        button.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
        return button
    }()
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    @objc func habitButtonTapped() {
        let vc = TrackerCreateViewController()
        vc.createHabitViewControllerDelegate = habitCreateViewControllerDelegate
        vc.isHabit = true
        present(vc, animated: true)
    }
    @objc func irregularEventButtonTapped() {
        let vc = TrackerCreateViewController()
        vc.createHabitViewControllerDelegate = habitCreateViewControllerDelegate
        present(vc, animated: true)
    }
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(buttonsStackView)
        view.addSubview(titleLabel)
        buttonsStackView.addArrangedSubview(habitButton)
        buttonsStackView.addArrangedSubview(irregularEventButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 140),
        ])
    }
}
