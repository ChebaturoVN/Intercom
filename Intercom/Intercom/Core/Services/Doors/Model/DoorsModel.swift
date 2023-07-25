//
//  DoorsModel.swift
//  Intercom
//
//  Created by VladimirCH on 23.07.2023.
//

import Foundation

struct DoorsModel: Codable {
    let success: Bool
    var data: [DoorsData]
}

struct DoorsData: Codable {
    var name: String
    let room: String?
    let id: Int
    var favorites: Bool
    let snapshot: String?
}
