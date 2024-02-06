//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Irina Deeva on 04/02/24.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private(set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?

    private init() { }

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if self.task != nil { return }

        var nextPage = 0

        if let lastPage = lastLoadedPage {
            nextPage = lastPage + 1
        } else {
            nextPage = 1
        }

        guard let request = imageListRequest(for: nextPage) else {return}

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResultResponse], Error>) in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let photoResponses):
                    let photos: [Photo] = photoResponses.map { photoResponse in
                        let photo = Photo(from: photoResponse)
                        return photo
                    }

                    self.photos.append(contentsOf: photos)

                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos" : photos]) // non lo so che e vero

                case .failure(let error):
                    // TODO: something different
                    print("\(error)")
                }
                self.task = nil
            }

        }

        self.lastLoadedPage = nextPage
        self.task = task
        task.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var request: URLRequest?

        if isLike {
            request = updateLikeRequest(for: photoId, method: "POST")
        } else {
            request = updateLikeRequest(for: photoId, method: "DELETE")
        }

        guard let request else { return }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResultResponse, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let photoResponse):

                    if let index = self.photos.firstIndex(where: { $0.id == photoResponse.photo.id }) {
                        let photo = self.photos[index]

                        let newPhoto = Photo(
                            id: photoResponse.photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: photoResponse.photo.isLiked
                        )

                        self.photos[index] = newPhoto

                        completion(.success(()))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }

}

extension ImagesListService {
    func imageListRequest(for page: Int) -> URLRequest? {
        return URLRequest.buildRequest(
            path: Constants.unsplashDefaultBaseURL + "photos",
            queryItems: [
                URLQueryItem(name: "page", value: String(page))
            ]
        )
    }

    func updateLikeRequest(for id: String, method: String) -> URLRequest? {
        return URLRequest.buildRequest(
            method: method,
            path: Constants.unsplashDefaultBaseURL + "photos/\(id)/like"
        )
    }
}
