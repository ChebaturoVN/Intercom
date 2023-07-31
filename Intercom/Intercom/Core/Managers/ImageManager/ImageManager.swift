//
//  ImageManager.swift
//  Intercom
//
//  Created by VladimirCH on 22.07.2023.
//

import UIKit

final class ImageManager {
    static let shared = ImageManager()

    private init() {}

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {

        URLSession(configuration: .default).dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)

            completion(image)
        }
        .resume()
    }
}

