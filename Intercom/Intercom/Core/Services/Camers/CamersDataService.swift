//
//  CamersDataService.swift
//  Intercom
//
//  Created by VladimirCH on 22.07.2023.
//

import Foundation

protocol CamersDataServiceProtocol {
    func getCamersList(completion: @escaping (CamersData?) -> Void)
}

final class CamersDataService: CamersDataServiceProtocol {

    func getCamersList(completion: @escaping(CamersData?) -> Void) {
        let restManager = RESTManager()
        guard let url = URL(string: "http://cars.cprogroup.ru/api/rubetek/cameras/") else { return }

        restManager.request(url: url, method: .get) { (response: APIResponse<CamersModel>) in

            if response.statusCode == 200, let data = response.data {
                let list = data.data
                completion(list)
            } else {
                print("Error occurred or invalid response")
            }
        }
    }
}
