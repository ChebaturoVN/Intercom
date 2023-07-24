//
//  ViewController.swift
//  Intercom
//
//  Created by VladimirCH on 21.07.2023.
//

import UIKit
import Combine

class ViewController: UIViewController {

    enum Constants {
        static let sectionHeaderHeight: CGFloat = 50
        static let lightGreyColor = UIColor(red: (234 / 255),
                                            green: (234 / 255),
                                            blue: (234 / 255),
                                            alpha: 1.0)
        static let conteinerColor = UIColor(red: (1),
                                            green: (1),
                                            blue: (1),
                                            alpha: 1.0)
        static var selectFlagCameras: Bool = true
    }

    @IBAction func СamerasButton(_ sender: Any) {
        cameraView.backgroundColor = .blue
        doorView.backgroundColor = .gray
        Constants.selectFlagCameras = true
        tableView.reloadData()
    }

    @IBAction func DoorsButton(_ sender: Any) {
        cameraView.backgroundColor = .gray
        doorView.backgroundColor = .blue
        Constants.selectFlagCameras = false
        tableView.reloadData()
    }

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var doorView: UIView!

    @IBOutlet weak var tableView: UITableView!

    let changeTextViewPublisher = PassthroughSubject<Bool, Never>()
    var cancellables: Set<AnyCancellable> = []

    private var camersDataService: CamersDataServiceProtocol = CamersDataService()
    private var doorsDataService: DoorsDataServiceProtocol = DoorsDataService()

    private var camersData: CamersData?
    private var doorsData: DoorsModel?

//    private var isEditingEnabled = false
    private var isEditingMode = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Мой дом"
        view.backgroundColor = Constants.lightGreyColor

        setupUI()
        targetUI()
        configurationStart()
    }

    private func targetUI() {
    }

    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.backgroundColor = Constants.lightGreyColor
        tableView.register(UINib(nibName: "CamerTableViewCell", bundle: nil), forCellReuseIdentifier: CamerTableViewCell.idCell)
        tableView.register(UINib(nibName: "DoorTableViewCell", bundle: nil), forCellReuseIdentifier: DoorTableViewCell.idCell)

    }

    private func configurationStart() {
        camersDataService.getCamersList { data in
            self.camersData = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        doorsDataService.getDoorsList { data in
            self.doorsData = data
        }
    }
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.selectFlagCameras ? (camersData?.room.count ?? 0) : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.selectFlagCameras ? (camersData?.cameras.count ?? 0) : (doorsData?.data.count ?? 1)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let camersHeaderView = CamersHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: Constants.sectionHeaderHeight))
        camersHeaderView.title = camersData?.room[section] ?? ""
        return Constants.selectFlagCameras ? camersHeaderView : UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.selectFlagCameras ? Constants.sectionHeaderHeight : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Constants.selectFlagCameras ?
        configCams(tableView, cellForRowAt: indexPath) :
        configDoors(tableView, cellForRowAt: indexPath)

    }

    func configCams(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CamerTableViewCell.idCell) as? CamerTableViewCell,
        let dataCam = camersData?.cameras else { return UITableViewCell() }

        cell.configure(dataCam[indexPath.row])
        return cell
    }

    func configDoors(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoorTableViewCell.idCell) as? DoorTableViewCell,
              let doorsData = doorsData?.data else { return UITableViewCell() }

        cell.configure(doorsData[indexPath.row])
        changeTextViewPublisher.sink { [weak self] flag in
            cell.setEditingMode(!flag)
            self?.isEditingMode = !(self?.isEditingMode ?? true)

        }.store(in: &cancellables)

        cell.textPublisher
            .print()
            .sink { [weak self] text in
                self?.camersData?.cameras[indexPath.row].name = text
            }
            .store(in: &cell.cancellables)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let editingAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in

            if let cell = tableView.cellForRow(at: indexPath) as? DoorTableViewCell {
                self.changeTextViewPublisher.send(self.isEditingMode)
            }
            completionHandler(true)
        }
        editingAction.image = UIImage(named: "doorEditing")
        editingAction.backgroundColor = Constants.lightGreyColor

        let favoritAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            if Constants.selectFlagCameras {
                guard var data = self.camersData else { return }
                data.cameras[indexPath.row].favorites = !(data.cameras[indexPath.row].favorites)
                self.camersData = data
                self.tableView.reloadData()
            } else {
                guard var data = self.doorsData else { return }
                data.data[indexPath.row].favorites = !(data.data[indexPath.row].favorites)
                self.doorsData = data
                self.tableView.reloadData()
            }
            completionHandler(true)
        }
        favoritAction.image = UIImage(named: "favoritEdition")
        favoritAction.backgroundColor = Constants.lightGreyColor

        let configuration = UISwipeActionsConfiguration(actions: Constants.selectFlagCameras ? [favoritAction] : [favoritAction, editingAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if Constants.selectFlagCameras {
                camersData?.cameras.remove(at: indexPath.row)
            } else {
                doorsData?.data.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
