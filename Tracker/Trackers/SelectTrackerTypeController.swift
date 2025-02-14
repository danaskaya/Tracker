//
//  TrackerCreateViewController.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 10.02.2025.
//

import UIKit
final class SelectTrackerTypeController: UIViewController {
    weak var habitCreateViewControllerDelegate: HabitCreateViewControllerDelegate?
    weak var irregularEventViewControllerDelegate: IrregularEventViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Создание трекера"
        title.font = .systemFont(ofSize: 16, weight: .medium)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    let habitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .black
        return button
    }()
    let irregularEventButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .black
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
        let vc = HabitCreateViewController()
        vc.createHabitViewControllerDelegate = habitCreateViewControllerDelegate
        present(vc, animated: true)
    }
    @objc func irregularEventButtonTapped() {
       let vc = IrregularEventViewController()
        vc.irregularEventViewControllerDelegate = irregularEventViewControllerDelegate
        present(vc, animated: true)
    }
    func setupViews() {
        view.backgroundColor = .white
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
            buttonsStackView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
}
