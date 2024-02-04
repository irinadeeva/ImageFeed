//
//  ProfileResultResponse.swift
//  ImageFeed
//
//  Created by Irina Deeva on 04/02/24.
//

import Foundation

struct ProfileResultResponse: Decodable {
    let userName: String
    let firstName: String
    let lastName: String?
    let bio: String?

    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
