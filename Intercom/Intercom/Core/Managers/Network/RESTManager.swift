//
//  RESTManager.swift
//  Intercom
//
//  Created by VladimirCH on 22.07.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct APIResponse<T: Codable> {
    let statusCode: Int
    var data: T?
}

class RESTManager {
    func request<T: Decodable>(url: URL, method: HTTPMethod, completion: @escaping (APIResponse<T>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(APIResponse(statusCode: 0, data: nil))
                return
            }

            let statusCode = httpResponse.statusCode
            var apiResponse = APIResponse<T>.init(statusCode: statusCode, data: nil)

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    apiResponse.data = decodedData

                } catch {
                    print("Error decoding response data: \(error)")
                    completion(apiResponse)
                }
            }

            completion(apiResponse)
        }
        task.resume()
    }

    typealias JSONTaskCompletionHandler = (Result<Any, Error>) -> Void

    func requestHttp(_ url: URL,
                     method: HTTPMethod,
                     params: [String: Any]? = nil,
                     completion: @escaping JSONTaskCompletionHandler) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let params = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch {
                completion(.failure(error))
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 1, userInfo: nil)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
