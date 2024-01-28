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
    }
    
    func fetchAuthToken(code: String, completionHandler: @escaping(Result<Data, Error>) -> Void) {
        var urlComponents = URLComponents(string: UnsplashTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectUR),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completionHandler(.failure(error))
            }

            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completionHandler(.failure(NetworkError.codeError))
            }

            guard let data else {return}
            
            completionHandler(.success(data))
        }
        
        task.resume()
    }
}
