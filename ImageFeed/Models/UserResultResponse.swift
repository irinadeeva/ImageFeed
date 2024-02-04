//
//  UserResultResponse.swift
//  ImageFeed
//
//  Created by Irina Deeva on 04/02/24.
//

import Foundation

struct UserResultResponse: Decodable {
    let profileImage: ProfileImage

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
