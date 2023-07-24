//
//  DoorsDataService.swift
//  Intercom
//
//  Created by VladimirCH on 23.07.2023.
//

import Foundation

protocol DoorsDataServiceProtocol {
    func getDoorsList(completion: @escaping (DoorsModel?) -> Void)
}

final class DoorsDataService: DoorsDataServiceProtocol {

    func getDoorsList(completion: @escaping (DoorsModel?) -> Void) {
        let restManager = RESTManager()
        guard let url = URL(string: "http://cars.cprogroup.ru/api/rubetek/doors/") else { return }

        restManager.request(url: url, method: .get) { (response: APIResponse<DoorsModel>) in

            if response.statusCode == 200, let data = response.data {
                completion(data)
            } else {
                print("Error occurred or invalid response")
            }
        }
    }
}

