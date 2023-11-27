//
//  URLComponents+init.swift
//  DateSpecialDetailsUsingNasa
//
//  Created by Onkar Verule on 14/10/23.
//

import Foundation

public extension URLComponents {

    init(scheme: String, host: String, path: String, queryItems: [URLQueryItem]? = nil) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        self = components
    }

    static func dateDetails(startDate: String, endDate: String) -> Self {
        let urlQueryItem = [
            URLQueryItem(name: "api_key", value: ViewModel.dataKey),
            URLQueryItem(name: "start_date", value: startDate),
            URLQueryItem(name: "end_date", value: endDate)
        ]
        return Self(scheme: "https", host: "api.nasa.gov", path: "/planetary/apod", queryItems: urlQueryItem)
    }
}
