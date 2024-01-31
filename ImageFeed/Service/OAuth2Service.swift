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

        guard let request = URLRequest.buildRequest(
            method: "POST",
            path: unsplashTokenURLString,
            queryItems: [
                URLQueryItem(name: "client_id", value: accessKey),
                URLQueryItem(name: "client_secret", value: secretKey),
                URLQueryItem(name: "redirect_uri", value: redirectUR),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]) else {return}

        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completionHandler(.failure(error))
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    completionHandler(.failure(NetworkError.codeError))
                }
                
                guard let data = data else {
                    completionHandler(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    
                    let resultString = decodedData.accessToken
                    completionHandler(.success(resultString))
                    
                } catch {
                    completionHandler(.failure(error))
                }
                
                self.task = nil
                if error != nil {
                    self.lastCode = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}
