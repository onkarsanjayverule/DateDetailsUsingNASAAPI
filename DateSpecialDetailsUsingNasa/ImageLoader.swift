//
//  ImageLoader.swift
//  DateSpecialDetailsUsingNasa
//
//  Created by Onkar Verule on 15/10/23.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    static var shared = ImageLoader()

    public func getImage(urlString: String, completion: @escaping (UIImage) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                completion(image)
            }
        }
        task.resume()
        return
    }

    private init() {}
}
