//
//  IrregularEmojiCollectionHeaderCell.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 13.02.2025.
//

import UIKit
final class IrregularEmojiCollectionHeaderCell: UICollectionReusableView {
    var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 19, weight: .bold)
        title.textColor = .black
        return title
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        NSLayoutConstraint.activate([title.topAnchor.constraint(equalTo: topAnchor),
                                     title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18)
                                    ])
    }
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
