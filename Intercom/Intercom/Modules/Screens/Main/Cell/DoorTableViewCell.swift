//
//  DoorTableViewCell.swift
//  Intercom
//
//  Created by VladimirCH on 23.07.2023.
//

import UIKit
import Combine

class DoorTableViewCell: UITableViewCell {

    static let idCell = "DoorTableViewCell"

    var textSubject = CurrentValueSubject<String, Never>("")
    var textPublisher = PassthroughSubject<String, Never>()

    var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var conteinerStatusView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func statusLockButton(_ sender: Any) {

    }

    @IBOutlet weak var editingTitleTextField: UITextField!

    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var playCamera: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear.withAlphaComponent(0)
        playCamera.layer.zPosition = cameraImage.layer.zPosition + 1

        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .clear.withAlphaComponent(0)

        contentView.backgroundColor = .clear.withAlphaComponent(0)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        conteinerStatusView.backgroundColor = ViewController.Constants.lightGreyColor
        playCamera.layer.zPosition = cameraImage.layer.zPosition + 1
        conteinerStatusView.layer.zPosition = titleLabel.layer.zPosition + 1
        conteinerStatusView.layer.cornerRadius = 20
        conteinerStatusView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        conteinerStatusView.layer.shadowColor = UIColor.gray.cgColor
        conteinerStatusView.layer.shadowOffset = CGSize(width: 0, height: 2)
        conteinerStatusView.layer.shadowRadius = 2.0
        conteinerStatusView.layer.shadowOpacity = 0.4
        conteinerStatusView.backgroundColor = ViewController.Constants.conteinerColor
        editingTitleTextField.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    func configure(_ data: DoorsData) {
        titleLabel.text = data.name
//        editingTitleTextField.isHidden = true
        editingTitleTextField.text = data.name

        if let snapshot = data.snapshot {
            cameraImage.isHidden = false
            playCamera.isHidden = false
            guard let url = URL(string: snapshot) else { return }
            ImageManager.shared.downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.cameraImage.image = image
                }
            }
            imageViewHeightConstraint.constant = 270.0
            statusLabel.isHidden = false
            statusLabel.text = "В сети"

        } else {
            cameraImage.isHidden = true
            playCamera.isHidden = true
            imageViewHeightConstraint.constant = 0.0
            statusLabel.isHidden = true
        }
    }

    func setEditingMode(_ isEditing: Bool) {
        if isEditing == true {
//            editingTitleTextField.publisher(for: \.text)
//                .compactMap { $0 }
//                .sink { [weak self] text in
            if let text = editingTitleTextField.text {
                self.textPublisher.send(text)
            }
//                }
//                .store(in: &cancellables)
        }
        self.editingTitleTextField.isHidden = isEditing
    }
}
