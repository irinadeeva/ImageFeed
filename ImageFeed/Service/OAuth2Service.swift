//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Irina Deeva on 26/01/24.
//

import Foundation

final class OAuth2Service {
    private enum NetworkError: Error {
        case codeError
        case noData
    }

    func fetchAuthToken(code: String, completionHandler: @escaping(Result<String, Error>) -> Void) {
        let request = buildRequest(with: code)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
            }
        }

        task.resume()
    }

    private func buildRequest(with code: String) -> URLRequest {
        var urlComponents = URLComponents(string: unsplashTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectUR),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return request
    }
}
