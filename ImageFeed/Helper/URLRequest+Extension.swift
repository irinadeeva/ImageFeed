//
//  URLRequestBuilder.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import Foundation

extension URLRequest {
    static func buildRequest(method: String? = nil,
                             path: String,
                             queryItems: [URLQueryItem]? = nil) -> URLRequest? {
        guard var urlComponents = URLComponents(string: path) else { return nil }

        if let queryItems {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)

        if let method {
            request.httpMethod = method
        }

        ///Customised for the Unsplash
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
