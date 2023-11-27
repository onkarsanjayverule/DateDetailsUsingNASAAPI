//
//  ViewModel.swift
//  DateSpecialDetailsUsingNasa
//
//  Created by Onkar Verule on 14/10/23.
//

import Foundation
import Combine
import SwiftyJSON
import UIKit

struct NasaData: Decodable {
    let copyright: String
    let date: String
    let explanation: String
    let hdurl: String
    let media_type: String
    let service_version: String
    let title: String
    let url: String
}

enum ResponseStatus {
    case Success
    case Failure
}

class ViewModel: ObservableObject {

    // https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&start_date=2017-07-08&end_date=2017-07-8

    @Published var dateText = "Date"
    @Published var titleText = "title"
    @Published var descriptionText = """
                              Sometimes it's more readable to format multiline text as a "block", which means starting it on a new line. All lines must be indented by at least one space.
                              """
    @Published var image = UIImage()

    public init() {
        fetchDataForDate(startDate: getCurrentDate(), endDate: getCurrentDate(), completion: { status in
            print(status)
        })
    }

    static let dataKey = "EhkBGr4gBuhnRXcTN9Kua0K13ZIndZ6qikMIcIYQ"

    func fetchDataForDate(startDate: String, endDate: String, completion: @escaping (ResponseStatus) -> Void) {
        let request : URLRequest = .init(components: URLComponents.dateDetails(startDate: startDate, endDate: endDate))

        URLSession.shared.dataTask(with: request) { data, respose, error in
            guard let data = data else {
                print("data is nil")
                return
            }

            guard let respose = respose as? HTTPURLResponse, 200 ... 299 ~= respose.statusCode else {
                completion(.Failure)
                return
            }

            let json = try? JSON(data: data).first
            guard let data = json?.1 else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.dateText = data["date"].stringValue
                self?.titleText = data["title"].stringValue
                self?.descriptionText = data["explanation"].stringValue
                ImageLoader.shared.getImage(urlString: data["url"].stringValue, completion: { image in
                    self?.image = image
                })
                completion(.Success)
            }
        }.resume()
    }

    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }

    func getDateByFormatting(date: Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
