//
//  DoorViewController.swift
//  Intercom
//
//  Created by VladimirCH on 25.07.2023.
//

import UIKit

class DoorViewController: UIViewController {

    @IBOutlet weak var doorNameLabel: UILabel!

    @IBOutlet weak var liveStreamView: UIView!
    @IBOutlet weak var liveStreamLabel: UILabel!

    @IBOutlet weak var fullScreenImageView: UIImageView!

    @IBOutlet weak var viewsOnlineViewImage: UIImageView!
    @IBOutlet weak var amountOnlineLabel: UILabel!

    @IBOutlet weak var snapshotImage: UIImageView!


    @IBOutlet weak var backImageView: UIImageView!

    @IBOutlet weak var openDoorTapView: UIView!

    var model: DoorsData?

    override func awakeFromNib() {

//        openDoorTapView.backgroundColor = .red

        view.backgroundColor = ViewController.Constants.lightGreyColor
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        tapGesture()
    }

    func congigure(_ model: DoorsData) {
        self.model = model
        DispatchQueue.main.async {
            self.doorNameLabel.text = model.name
        }
        guard let snapshot = model.snapshot,
                let url = URL(string: snapshot) else { return }
        ImageManager.shared.downloadImage(from: url) { image in
            DispatchQueue.main.async {
                self.snapshotImage.image = image
                self.liveStreamView.isHidden = false
                self.liveStreamLabel.isHidden = false
                self.fullScreenImageView.isHidden = true
                self.viewsOnlineViewImage.isHidden = true
                self.amountOnlineLabel.isHidden = true
            }
        }
    }

    private func setupUI() {
        liveStreamView.layer.masksToBounds = true
        liveStreamView.layer.cornerRadius = 10
        liveStreamView.backgroundColor = .red

        liveStreamView.isHidden = true
        liveStreamLabel.isHidden = true
        fullScreenImageView.isHidden = true
        viewsOnlineViewImage.isHidden = true
        amountOnlineLabel.isHidden = true

        openDoorTapView.layer.masksToBounds = true
        openDoorTapView.layer.cornerRadius = 20
    }

    private func tapGesture() {
        let tapFullScreenGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(fullScreenTapped(_:))
        )
        fullScreenImageView.addGestureRecognizer(tapFullScreenGestureRecognizer)
        fullScreenImageView.isUserInteractionEnabled = true


        let tapBackGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(backTapped(_:))
        )
        backImageView.addGestureRecognizer(tapBackGestureRecognizer)
        backImageView.isUserInteractionEnabled = true
    }

    @objc
    private func fullScreenTapped(_ gestureRecognizer: UITapGestureRecognizer) {

        print("fullScreenTapped")
    }

    @objc
    private func backTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
        print("backTapped")
    }

}
