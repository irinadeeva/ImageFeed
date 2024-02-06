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
    let isLiked: Bool

    init(from photo: PhotoResultResponse) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)

        if let createdAtString = photo.createdAtString {
            createdAt = Self.dateFormatterISO8601.date(from: createdAtString)
        } else {
            createdAt = nil
        }

        self.welcomeDescription = photo.welcomeDescription
        self.thumbImageURL = photo.urls.thumb.absoluteString
        self.largeImageURL = photo.urls.full.absoluteString
        self.isLiked = photo.isLiked
    }

    init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}

extension Photo {
    private static let dateFormatterISO8601 = ISO8601DateFormatter()
}
