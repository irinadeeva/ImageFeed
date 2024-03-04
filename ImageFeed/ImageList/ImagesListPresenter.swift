//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Irina Deeva on 08/02/24.
//

import UIKit
import Kingfisher

protocol ImagesListPresenterProtocol: AnyObject {
    func fetchPhotosNextPage()
    func getPhotos() -> [Photo]
    func getPhotosNumber() -> Int
    func changeLike(photo: Photo, _ completion: @escaping (Result<Void, Error>) -> Void)
    func getCachedImage(by url: String, completion: @escaping (Result<RetrieveImageResult, KingfisherError>) -> Void)
    func getAlertModel() -> AlertModel
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListService.shared

    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }

    func getPhotos() -> [Photo] {
        return imagesListService.photos
    }

    func getPhotosNumber() -> Int {
        return imagesListService.photos.count
    }

    func changeLike(photo: Photo, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked, completion)
    }

    func getCachedImage(by url: String, completion: @escaping (Result<RetrieveImageResult, KingfisherError>) -> Void) {
        guard let imageURL = URL(string: url) else { return }

        KingfisherManager.shared.retrieveImage(with: imageURL, completionHandler: completion)
    }

    func getAlertModel() -> AlertModel {
        return AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonTexts: ["OK"]
        ) { [weak self] index in
            guard let self else {return}

            fetchPhotosNextPage()
        }
    }
}
