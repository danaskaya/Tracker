//
//  TrackerCell.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 10.02.2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, indexPath: IndexPath)
    func uncompleteTracker(id: UUID, indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    private var isComplete: Bool = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    weak var delegate: TrackerCellDelegate?
    private var emoji = UILabel()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    private var emojiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let trackerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    @objc func plusButtonTapped() {
        guard let trackerID = trackerID, let indexPath = indexPath else {
            assertionFailure("no tracker id")
            return
        }
        if isComplete {
            delegate?.uncompleteTracker(id: trackerID, indexPath: indexPath)
        } else {
            delegate?.completeTracker(id: trackerID, indexPath: indexPath)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        [countLabel, trackerView, plusButton].forEach {
            contentView.addSubview($0)
        }
        trackerView.addSubview(label)
        trackerView.addSubview(emojiView)
        emojiView.addSubview(emoji)
    }
    private func setupConstraints() {
        emoji.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            plusButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            label.topAnchor.constraint(equalTo: emojiView.bottomAnchor,constant: 5),
            label.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            
            emoji.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    func set(object: Tracker,
             isComplete: Bool,
             completedDays: Int,
             indexPath: IndexPath
    ) {
        lazy var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        self.indexPath = indexPath
        self.isComplete = isComplete
        self.trackerID = object.id
        self.trackerView.backgroundColor = object.color
        if !isComplete {
            self.plusButton.backgroundColor = object.color
            self.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            self.plusButton.backgroundColor = object.color.withAlphaComponent(0.5)
            self.plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        self.trackerView.layer.cornerRadius = 16
        let wordDay = convertCompletedDays(completedDays)
        countLabel.text = "\(wordDay)"
        self.label.attributedText = NSMutableAttributedString(string: object.name, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.label.textColor  = .white
        self.emojiView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        self.emojiView.layer.cornerRadius = 13
        self.emoji.text = object.emoji
        self.emoji.textAlignment = .center
        self.emoji.font = .systemFont(ofSize: 12)
        self.layer.cornerRadius = 16
    }
    private func convertCompletedDays(_ completedDays: Int) -> String {
        let number = completedDays % 10
        let lastTwoNumbers = completedDays % 100
        if lastTwoNumbers >= 11 && lastTwoNumbers <= 19 {
            return "\(completedDays) дней"
        }
        switch number {
        case 1:
            return "\(completedDays) день"
        case 2, 3, 4:
            return "\(completedDays) дня"
        default:
            return "\(completedDays) дней"
        }
    }
}
