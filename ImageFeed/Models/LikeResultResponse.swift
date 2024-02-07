//
//  LikeResultResponse.swift
//  ImageFeed
//
//  Created by Irina Deeva on 06/02/24.
//

import Foundation

struct LikeResultResponse: Decodable {
    let photo: LikeImage

    private enum CodingKeys: String, CodingKey {
        case photo = "photo"
    }
}

struct LikeImage: Decodable {
    let id: String
    let isLiked: Bool

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case isLiked = "liked_by_user"
    }
}
