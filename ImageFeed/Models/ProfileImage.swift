//
//  UserResult.swift
//  ImageFeed
//
//  Created by Irina Deeva on 01/02/24.
//

import Foundation

struct UserRespondResult: Decodable {
    let profileImage: ProfileImage

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: URL
    let medium: URL
    let large: URL

    private enum CodingKeys: String, CodingKey {
        case small = "small"
        case medium = "medium"
        case large = "large"
    }
}
