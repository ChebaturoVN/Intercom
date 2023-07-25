//
//  ViewController.swift
//  Intercom
//
//  Created by VladimirCH on 21.07.2023.
//

import UIKit

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

    private var camersDataService: CamersDataServiceProtocol = CamersDataService()
    private var doorsDataService: DoorsDataServiceProtocol = DoorsDataService()

    private var realmManagerProtocol: RealmManagerProtocol = RealmManager.shared

    private var camersModel: CamersModel?
    private var doorsModel: DoorsModel?

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
        realmManagerProtocol.getCamersModel { result in
            switch result {

            case .success(let camers):
                DispatchQueue.main.async {
                    self.camersModel = camers
                    self.updateTableView()
                }

            case .failure(_):
                self.camersDataService.getCamersList { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.camersModel = data
                            self.realmManagerProtocol.saveCamersModel(data)
                            self.updateTableView()
                        }
                    case .failure(let error):
                        print(error.message ?? "" + (error.error?.localizedDescription ?? ""))
                    }
                }
            }
        }
        realmManagerProtocol.getDoorsModel { result in
            switch result {
            case .success(let doors):
                DispatchQueue.main.async {
                    self.doorsModel = doors
                    self.updateTableView()
                }
            case .failure(_):
                self.doorsDataService.getDoorsList { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.doorsModel = data
                            self.realmManagerProtocol.saveDoorsModel(data)
                            self.updateTableView()
                        }
                    case .failure(let error):
                        print(error.message ?? "" + (error.error?.localizedDescription ?? ""))
                    }

                }

            }
        }
    }

    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.selectFlagCameras ? (camersModel?.data.room.count ?? 0) : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.selectFlagCameras ? (camersModel?.data.cameras.count ?? 0) : (doorsModel?.data.count ?? 1)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let camersHeaderView = CamersHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: Constants.sectionHeaderHeight))
        camersHeaderView.title = camersModel?.data.room[section] ?? ""
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
              let dataCam = camersModel?.data.cameras else { return UITableViewCell() }

        cell.configure(dataCam[indexPath.row])
        return cell
    }

    func configDoors(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoorTableViewCell.idCell) as? DoorTableViewCell,
              let doorsData = doorsModel?.data else { return UITableViewCell() }

        cell.configure(doorsData[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let editingAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in

            if let cell = (tableView.cellForRow(at: indexPath) as? DoorTableViewCell) {
                cell.setEditingMode()
                cell.textPublisher
                    .sink { [weak self] text in
                        print(text)
                        self?.doorsModel?.data[indexPath.row].name = text
                        if let data = self?.doorsModel {
                            self?.realmManagerProtocol.updateDoorsModel(data)
                        }
                        self?.updateTableView()
                    }
                    .store(in: &cell.cancellables)
            }
            completionHandler(true)
        }
        editingAction.image = UIImage(named: "doorEditing")
        editingAction.backgroundColor = Constants.lightGreyColor

        let favoritAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            if Constants.selectFlagCameras {
                guard var data = self.camersModel?.data else { return }
                data.cameras[indexPath.row].favorites = !(data.cameras[indexPath.row].favorites)
                self.camersModel?.data = data
                if let camersModel = self.camersModel {
                    self.realmManagerProtocol.updateCamersModel(camersModel)
                }

                self.tableView.reloadData()
            } else {
                guard var data = self.doorsModel else { return }
                data.data[indexPath.row].favorites = !(data.data[indexPath.row].favorites)
                self.doorsModel = data

                self.realmManagerProtocol.updateDoorsModel(data)
                self.tableView.reloadData()
            }
            completionHandler(true)
        }
        favoritAction.image = UIImage(named: "favoritEdition")
        favoritAction.backgroundColor = Constants.lightGreyColor

        let configuration = UISwipeActionsConfiguration(actions: Constants.selectFlagCameras ? [favoritAction] : [favoritAction, editingAction])
        return configuration
    }
}
