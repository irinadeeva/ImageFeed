//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Irina Deeva on 26/01/24.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?

    private init() { }

    func fetchAuthToken(code: String, completionHandler: @escaping(Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code

        guard let request = authTokenRequest(with: code) else {return}

        let task = urlSession.objectTask(with: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completionHandler(.success(data.accessToken))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }

        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    func authTokenRequest(with code: String) -> URLRequest? {
        return URLRequest.buildRequest(
            method: "POST",
            path: unsplashTokenURLString,
            queryItems: [
                URLQueryItem(name: "client_id", value: accessKey),
                URLQueryItem(name: "client_secret", value: secretKey),
                URLQueryItem(name: "redirect_uri", value: redirectUR),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ])
    }
}
