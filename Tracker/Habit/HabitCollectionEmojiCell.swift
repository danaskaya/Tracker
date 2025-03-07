//
//  HabitCollectionEmojiCell.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 12.02.2025.
//

import UIKit
final class HabitCollectionEmojiCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        return label
    }()
    var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellView)
        cellView.addSubview(label)
        NSLayoutConstraint.activate([
            cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            cellView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            label.widthAnchor.constraint(equalToConstant: 45),
            label.heightAnchor.constraint(equalToConstant: 45)
            
        ])
    }
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
