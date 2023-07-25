//
//  DoorsModelObject.swift
//  Intercom
//
//  Created by VladimirCH on 24.07.2023.
//

import Foundation
import RealmSwift

class DoorsModelObject: Object {
    @objc dynamic var success: Bool = false
    var data = List<DoorsDataObject>()

}

class DoorsDataObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var room: String?
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
    @objc dynamic var snapshot: String?
}
