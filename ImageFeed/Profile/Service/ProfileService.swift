//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private init() {}

    func fetchProfile(_ token: String, completionHandler: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let request = profileRequest() else { return }

        let task = urlSession.objectTask(with: request) 
        { (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let profile = Profile(profileResult: data)
                    print("ProfileService fetchProfile")
                    print(profile)
                    completionHandler(.success(profile))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }

        task.resume()    
    }

    func updateProfile(_ profile: Profile) {
        print("Profile service updateProfile")
        print(profile)
        self.profile = profile
    }
}

extension ProfileService {
    func profileRequest() -> URLRequest? {
        return URLRequest.buildRequest(
            path: unsplashDefaultBaseURL + "me")
    }
}