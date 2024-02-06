//
//  Photo.swift
//  ImageFeed
//
//  Created by Irina Deeva on 04/02/24.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool

    init(from photo: PhotoResultResponse) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = photo.createdAtString?.changeToDate
        self.welcomeDescription = photo.welcomeDescription
        self.thumbImageURL = photo.urls.thumb.absoluteString
        self.largeImageURL = photo.urls.full.absoluteString
        self.isLiked = photo.isLiked
    }

    mutating func toggleLike() {
        self.isLiked = !self.isLiked
    }
}
