//
//  CamerTableViewCell.swift
//  Intercom
//
//  Created by VladimirCH on 22.07.2023.
//

import UIKit

class CamerTableViewCell: UITableViewCell {

    static let idCell = "CamerTableViewCell"

    @IBOutlet weak var playViewImage: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var recImageView: UIImageView!

    @IBOutlet weak var conteinerForTitleView: UIView!

    @IBOutlet weak var cameraTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = .clear.withAlphaComponent(0)
        favoriteImageView.layer.zPosition = cameraImageView.layer.zPosition + 1
        playViewImage.layer.zPosition = cameraImageView.layer.zPosition + 1
        recImageView.layer.zPosition = cameraImageView.layer.zPosition + 1

        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .clear.withAlphaComponent(0)

        contentView.backgroundColor = .clear.withAlphaComponent(0)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        conteinerForTitleView.backgroundColor = ViewController.Constants.lightGreyColor
        conteinerForTitleView.layer.cornerRadius = 20
        conteinerForTitleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        conteinerForTitleView.layer.shadowColor = UIColor.gray.cgColor
        conteinerForTitleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        conteinerForTitleView.layer.shadowRadius = 2.0
        conteinerForTitleView.layer.shadowOpacity = 0.4
        conteinerForTitleView.backgroundColor = ViewController.Constants.conteinerColor
    }


    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        }

    func configure(_ data: CamerasList) {

        guard let url = URL(string: data.snapshot) else { return }
        ImageManager.shared.downloadImage(from: url) { image in
            DispatchQueue.main.async {
                self.cameraImageView.image = image
            }
        }
        cameraTitleLabel.text = data.name
        favoriteImageView.isHidden = !data.favorites
        recImageView.isHidden = !data.rec
    }
    
}
