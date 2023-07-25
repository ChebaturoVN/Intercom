//
//  CamersModelObject.swift
//  Intercom
//
//  Created by VladimirCH on 24.07.2023.
//

import Foundation
import RealmSwift

class CamersModelObject: Object {
    @objc dynamic var success: Bool = false
    @objc dynamic var data: CamersDataObject?
}

class CamersDataObject: Object {
    var room = List<String>()
    var cameras = List<CamerasListObject>()
}

class CamerasListObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var snapshot: String = ""
    @objc dynamic var room: String? = nil
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
    @objc dynamic var rec: Bool = false
}
