//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import Foundation

final class ProfileService {
    private var tokenStorage = OAuth2TokenStorage.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = profileRequest() else { return }


//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//            if let error {
//                handler(.failure(error))
//            }
//
//            if let response = response as? HTTPURLResponse,
//               response.statusCode < 200 || response.statusCode >= 300 {
//                handler(.failure(NetworkError.codeError))
//            }
//
//            guard let data else {return}
//            handler(.success(data))
//        }

//        task.resume()
        
    }
}

extension ProfileService {
    func profileRequest() -> URLRequest? {
        return URLRequest.buildRequest(
            path: unsplashDefaultBaseURL + "me")
    }
}