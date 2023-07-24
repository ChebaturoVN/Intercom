//
//  CamersModel.swift
//  Intercom
//
//  Created by VladimirCH on 22.07.2023.
//

import Foundation

struct CamersModel: Codable {
    let success: Bool
    let data: CamersData
}

struct CamersData: Codable {
    let room: [String]
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
