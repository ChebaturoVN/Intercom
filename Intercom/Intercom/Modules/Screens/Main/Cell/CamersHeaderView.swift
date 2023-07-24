//
//  CamersHeaderView.swift
//  Intercom
//
//  Created by VladimirCH on 23.07.2023.
//

import UIKit

class CamersHeaderView: UITableViewHeaderFooterView {

    var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: UIScreen.main.bounds.width - 32, height: ViewController.Constants.sectionHeaderHeight))
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "12121"
        return label
    }()

    init(frame: CGRect) {
        super.init(reuseIdentifier: nil)
        self.frame = frame
        setupUI()


    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 120),
            titleLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
