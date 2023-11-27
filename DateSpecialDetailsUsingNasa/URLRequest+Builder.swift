//
//  URLRequest+Builder.swift
//  DateSpecialDetailsUsingNasa
//
//  Created by Onkar Verule on 14/10/23.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public extension URLRequest {
    init(components: URLComponents) {
        guard let url = components.url else {
            preconditionFailure("Unable to get URL from URLComponents: \(components)")
        }

        self = Self(url: url)
            .add(headers: ["Content" : "application/json"])
    }

    private func map(_ transform: (inout Self) -> ()) -> Self {
        var request = self
        transform(&request)
        return request
    }

    func add(httpMethod: HTTPMethod) -> Self {
        map { $0.httpMethod = httpMethod.rawValue }
    }

    func add<Body: Encodable>(body: Body) -> Self {
        map {
            do {
                $0.httpBody = try JSONEncoder().encode(body)
            } catch {
                preconditionFailure("Failed to encode request body: \(body) due to error: \(error)")
            }
        }
    }

    func add(headers: [String: String]) -> Self {
        map {
            let allHTTPheadersField = $0.allHTTPHeaderFields ?? [:]

            let updatedAllHTTPHeaderField = headers.merging(allHTTPheadersField, uniquingKeysWith: { $1 })
            $0.allHTTPHeaderFields = updatedAllHTTPHeaderField
        }
    }
}
