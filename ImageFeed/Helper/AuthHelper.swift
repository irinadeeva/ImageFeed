//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Irina Deeva on 07/02/24.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }

    func authRequest() -> URLRequest? {
        return URLRequest.buildRequest(
            path: AuthConfiguration.standard.unsplashAuthorizeURLString,
            queryItems: [
                URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
                URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectUR),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: AuthConfiguration.standard.accessScope)
        ])
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    

}
