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

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResultResponse], Error>) in DispatchQueue.main.async {
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

                //                print(self.photos)
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
//        let newPhoto: LikeResultResponse?

        if isLike {
            addToFavorite(for: photoId)
        } else {
            deleteFromFavorite(for: photoId)
        }

//        guard let newPhoto else { return }
//
//        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
//            var photo = self.photos[index]
//
//            let newPhoto = photo.toggleLike()
//
//            self.photos[index] = newPhoto
//        }

    }

    private func addToFavorite(for photoId: String) {
        guard let request = updateLikeRequest(for: photoId) else { return }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResultResponse, Error>) in DispatchQueue.main.async {
            guard let self else { return }

            switch result {
            case .success(let photoResponse):
                print("addToFavorite photoResponse \(photoResponse)")

            case .failure(let error):
                // TODO: something different
                print("addToFavorite error \(error)")
            }
        }
        }

        task.resume()
    }

    private func deleteFromFavorite(for photoId: String) {
//        return nil
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

    func updateLikeRequest(for id: String) -> URLRequest? {
        return URLRequest.buildRequest(
            method: "POST",
            path: Constants.unsplashDefaultBaseURL + "photos/\(id)/like"
        )
    }
}
