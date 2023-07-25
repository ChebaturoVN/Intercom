//
//  RealmManager.swift
//  Intercom
//
//  Created by VladimirCH on 24.07.2023.
//

import Foundation
import RealmSwift

protocol RealmManagerProtocol: AnyObject {
    func saveCamersModel(_ model: CamersModel)
    func updateCamersModel(_ model: CamersModel)
    func getCamersModel(completion: @escaping (Result<CamersModel,
                                               Error>) -> Void)
    func deleteCamers(camers: CamersModelObject)
    func saveDoorsModel(_ model: DoorsModel)
    func updateDoorsModel(_ model: DoorsModel)
    func getDoorsModel(completion: @escaping (Result<DoorsModel,
                                              Error>) -> Void)
    func deleteCamers(doors: DoorsModelObject)
}

final class RealmManager: RealmManagerProtocol {

    static let shared = RealmManager()

    private let realm: Realm

    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    func saveCamersModel(_ model: CamersModel) {

        let camersModelObject = CamersModelObject()
        camersModelObject.success = model.success

        let data = model.data
        let dataObject = CamersDataObject()
        dataObject.room.append(objectsIn: data.room)

        for camera in data.cameras {
            let cameraObject = CamerasListObject()
            cameraObject.name = camera.name
            cameraObject.snapshot = camera.snapshot
            cameraObject.room = camera.room
            cameraObject.id = camera.id
            cameraObject.favorites = camera.favorites
            cameraObject.rec = camera.rec
            dataObject.cameras.append(cameraObject)
        }

        camersModelObject.data = dataObject
        do {
            try realm.write {
                realm.add(camersModelObject)
            }
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }

    func getCamersModel(completion: @escaping (Result<CamersModel, Error>) -> Void) {
        do {
            guard let camersModelObject = realm.objects(CamersModelObject.self).first else {
                let error = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "CamersModelObject not found"])
                completion(.failure(error))
                return
            }

            let camersModel = CamersModel(
                success: camersModelObject.success,
                data: CamersData(
                    room: Array(camersModelObject.data?.room ?? List<String>()),
                    cameras: camersModelObject.data?.cameras.map {
                        CamerasList(
                            name: $0.name,
                            snapshot: $0.snapshot,
                            room: $0.room,
                            id: $0.id,
                            favorites: $0.favorites,
                            rec: $0.rec
                        )
                    } ?? []
                )
            )

            completion(.success(camersModel))
        } catch {
            completion(.failure(error))
        }
    }

    func deleteCamers(camers: CamersModelObject) {
        try? realm.write {
            realm.delete(camers)
        }
    }

    func saveDoorsModel(_ model: DoorsModel) {
        let doorsModelObject = DoorsModelObject()
        doorsModelObject.success = model.success

        for doorData in model.data {
            let doorDataObject = DoorsDataObject()
            doorDataObject.name = doorData.name
            doorDataObject.room = doorData.room
            doorDataObject.id = doorData.id
            doorDataObject.favorites = doorData.favorites
            doorDataObject.snapshot = doorData.snapshot
            doorsModelObject.data.append(doorDataObject)
        }

        do {
            try realm.write {
                realm.add(doorsModelObject)
            }
        } catch {
            print("Error saving DoorsModel: \(error)")
        }
    }

    func updateCamersModel(_ model: CamersModel) {
        do {
            try realm.write {
                let existingCamersModelObject = realm.objects(CamersModelObject.self)
                    .filter("success == %@", model.success)
                realm.delete(existingCamersModelObject)

                let camersModelObject = CamersModelObject()
                camersModelObject.success = model.success
                let data = model.data
                let dataObject = CamersDataObject()
                dataObject.room.append(objectsIn: data.room)

                for camera in data.cameras {
                    let cameraObject = CamerasListObject()
                    cameraObject.name = camera.name
                    cameraObject.snapshot = camera.snapshot
                    cameraObject.room = camera.room
                    cameraObject.id = camera.id
                    cameraObject.favorites = camera.favorites
                    cameraObject.rec = camera.rec
                    dataObject.cameras.append(cameraObject)
                }

                camersModelObject.data = dataObject

                try realm.write {
                    realm.add(camersModelObject)
                }
            }
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }

    func updateDoorsModel(_ model: DoorsModel) {
        do {
            try realm.write {
                let existingModels = realm.objects(DoorsModelObject.self).filter("success == %@", model.success)
                realm.delete(existingModels)

                let doorsModelObject = DoorsModelObject()
                doorsModelObject.success = model.success
                model.data.forEach { doorsData in
                    let data = DoorsDataObject()
                    data.name = doorsData.name
                    data.room = doorsData.room
                    data.id = doorsData.id
                    data.favorites = doorsData.favorites
                    data.snapshot = doorsData.snapshot
                    doorsModelObject.data.append(data)
                }

                realm.add(doorsModelObject)
            }
        } catch {
            print("Error saving DoorsModelRealm: \(error)")
        }
    }

    func getDoorsModel(completion: @escaping (Result<DoorsModel, Error>) -> Void) {
        do {
            guard let doorsModelObject = realm.objects(DoorsModelObject.self).first else {
                let error = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "CamersModelObject not found"])
                completion(.failure(error))
                return
            }
            let doorsModel = DoorsModel(
                success: doorsModelObject.success,
                data: doorsModelObject.data.map {
                    DoorsData(
                        name: $0.name,
                        room: $0.room,
                        id: $0.id,
                        favorites: $0.favorites,
                        snapshot: $0.snapshot
                    )
                }
            )
            completion(.success(doorsModel))
        } catch {
            completion(.failure(error))
        }
    }

    func deleteCamers(doors: DoorsModelObject) {
        try? realm.write {
            realm.delete(doors)
        }
    }

}
