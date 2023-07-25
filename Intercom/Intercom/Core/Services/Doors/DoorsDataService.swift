//
//  DoorsDataService.swift
//  Intercom
//
//  Created by VladimirCH on 23.07.2023.
//

import Foundation

protocol DoorsDataServiceProtocol {
    func getDoorsList(completion: @escaping (Result<DoorsModel, APIErrorMessage>) -> Void)
}

final class DoorsDataService: DoorsDataServiceProtocol {

    func getDoorsList(completion: @escaping (Result<DoorsModel, APIErrorMessage>) -> Void) {
        let restManager = RESTManager()
        guard let url = URL(string: "http://cars.cprogroup.ru/api/rubetek/doors/") else {
            completion(.failure(.init(message: "", error: nil)))
            return }

        restManager.request(url: url, method: .get) { (response: APIResponse<DoorsModel>) in

            if response.statusCode == 200, let data = response.data {
                completion(.success(data) )
            } else {
                completion(.failure(.init(message: "\(response.statusCode)", error: response.error)))
            }
        }
    }
}

