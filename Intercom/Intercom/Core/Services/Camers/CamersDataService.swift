//
//  CamersDataService.swift
//  Intercom
//
//  Created by VladimirCH on 22.07.2023.
//

import Foundation

protocol CamersDataServiceProtocol {
    func getCamersList(completion: @escaping (Result<CamersModel, APIErrorMessage>) -> Void)
}

final class CamersDataService: CamersDataServiceProtocol {

    func getCamersList(completion: @escaping(Result<CamersModel, APIErrorMessage>) -> Void) {
        let restManager = RESTManager()
        guard let url = URL(string: "http://cars.cprogroup.ru/api/rubetek/cameras/") else {             completion(.failure(.init(message: "", error: nil)))
            return }

        restManager.request(url: url, method: .get) { (response: APIResponse<CamersModel>) in

            if response.statusCode == 200, let data = response.data {
                completion(.success(data))
            } else {
                completion(.failure(.init(message: "\(response.statusCode)", error: response.error)))
            }
        }
    }
}
