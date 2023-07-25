//
//  CamersModel.swift
//  Intercom
//
//  Created by VladimirCH on 22.07.2023.
//

import Foundation

struct CamersModel: Codable {
    var success: Bool
    var data: CamersData
}

struct CamersData: Codable {
    var room: [String]
    var cameras: [CamerasList]
}

struct CamerasList: Codable {
    var name: String
    let snapshot: String
    let room: String?
    let id: Int
    var favorites: Bool
    let rec: Bool
}
