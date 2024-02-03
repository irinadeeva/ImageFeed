//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Irina Deeva on 01/02/24.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared

    private init() {}

    func fetchProfileImageURL(username: String, _ completionHandler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let request = profileImageRequest(for: username) else { return }

        let task = urlSession.objectTask(for: request)
        { (result: Result<UserRespondResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let smallImageURL = data.profileImage.small.absoluteString
                    completionHandler(.success(smallImageURL))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }

        task.resume()
    }

    func updateImageProfile(with imageURL: String) {
        self.avatarURL = imageURL
    }

}

extension ProfileImageService {
    func profileImageRequest(for username: String) -> URLRequest? {
            return URLRequest.buildRequest(
                path: unsplashDefaultBaseURL + "users/\(username)")

    }
}
